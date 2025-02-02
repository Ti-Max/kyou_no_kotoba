defmodule DiscordConsumer do
  use Nostrum.Consumer

  alias Nostrum.Struct.Component
  alias Nostrum.Constants
  alias Nostrum.Api

  require Logger

  @application_command Constants.InteractionType.application_command()
  @modal_submit Nostrum.Constants.InteractionType.modal_submit()

  @new_word_form "new_word_form"

  @impl true
  def handle_event({:GUILD_AVAILABLE, %{id: guild_id} = msg, _}) do
    dbg(msg)

    command = %{
      name: "new",
      description: "Create new 今日の言葉"
    }

    {:ok, _} = Api.create_guild_application_command(guild_id, command)
  end

  def handle_event({:INTERACTION_CREATE, %{type: @application_command} = interaction, _}) do
    response = %{
      type: Constants.InteractionCallbackType.modal(),
      data: %{
        title: "Create new 今日の言葉",
        custom_id: @new_word_form,
        components: [
          Component.ActionRow.action_row(
            components: [
              Component.TextInput.text_input(
                "言葉 / Word",
                "word",
                style: Constants.TextInputStyle.short(),
                min_length: 1,
                max_length: 30,
                placeholder: "言葉",
                required: true
              )
            ]
          ),
          Component.ActionRow.action_row(
            components: [
              Component.TextInput.text_input(
                "Translation",
                "translation",
                style: Constants.TextInputStyle.short(),
                min_length: 1,
                max_length: 100,
                placeholder: "word, language",
                required: true
              )
            ]
          ),
          Component.ActionRow.action_row(
            components: [
              Component.TextInput.text_input(
                "Kana",
                "kana",
                style: Constants.TextInputStyle.short(),
                min_length: 1,
                max_length: 50,
                placeholder: "ことば",
                required: false
              )
            ]
          ),
          Component.ActionRow.action_row(
            components: [
              Component.TextInput.text_input(
                "Example",
                "example",
                style: Constants.TextInputStyle.paragraph(),
                min_length: 1,
                max_length: 200,
                placeholder: "それが今日の言葉です",
                required: false
              )
            ]
          ),
          Component.ActionRow.action_row(
            components: [
              Component.TextInput.text_input(
                "Additional info",
                "extra",
                style: Constants.TextInputStyle.paragraph(),
                min_length: 1,
                max_length: 2000,
                placeholder: "kanji, mnemonic, anything else",
                required: false
              )
            ]
          )
        ]
      }
    }

    case Api.create_interaction_response(interaction, response) do
      {:ok} -> Logger.info("Open new word modal")
      {:error, error} -> Logger.error(error)
    end
  end

  def handle_event(
        {:INTERACTION_CREATE,
         %{type: @modal_submit, data: %{custom_id: @new_word_form} = data} = interaction, _}
      ) do
    dbg(data)

    response = %{
      type: Constants.InteractionCallbackType.channel_message_with_source(),
      data: %{content: compose_response(data)}
    }

    # TODO: log who submitted what
    case Api.create_interaction_response(interaction, response) do
      {:ok} -> Logger.info("New word form has been submitted")
      {:error, error} -> Logger.error(error)
    end
  end

  defp compose_response(data) do
    """
    # 新しい言葉! / New word! 

    ## #{get_field(data, "word")} - ||#{get_field(data, "translation")}||
    """
    |> maybe_add_kana(get_field(data, "kana"))
    |> maybe_add_example(get_field(data, "example"))
    |> maybe_add_extra(get_field(data, "extra"))
  end

  defp maybe_add_kana(text, nil), do: text

  defp maybe_add_kana(text, kana) do
    text <>
      """

      Kana - ||#{kana}||
      """
  end

  defp maybe_add_example(text, nil), do: text

  defp maybe_add_example(text, example) do
    text <>
      """

      Example:
      *#{example}*
      """
  end

  defp maybe_add_extra(text, nil), do: text

  defp maybe_add_extra(text, extra) do
    text <>
      """

      Addition info:
      *#{extra}*
      """
  end

  defp get_field(%{components: components}, id) do
    components
    |> Enum.find_value(fn
      %{components: [%{custom_id: ^id, value: ""}]} -> nil
      %{components: [%{custom_id: ^id, value: value}]} -> value
      _ -> nil
    end)
  end
end
