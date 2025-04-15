FROM elixir:1.18-alpine as build

# Install build dependencies
RUN apk add --no-cache build-base git

# Set workdir
WORKDIR /app

# Set environment for production release
ENV MIX_ENV=prod

# Install Hex and Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy project files and fetch deps
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only prod && mix deps.compile

# Copy the rest of the app
COPY lib lib

# Build the release
RUN mix release

# Runtime Stage
FROM alpine:3.18

# Install required runtime dependencies
RUN apk add --no-cache libstdc++ openssl ncurses-libs

# Set working directory
WORKDIR /app

# Copy release from build stage
COPY --from=build /app/_build/prod/rel/kyou_no_kotoba ./

# Set environment variables
ENV MIX_ENV=prod

# Start the app
CMD ["bin/kyou_no_kotoba", "start"]

