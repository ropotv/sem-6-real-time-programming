# Get the elixir library
FROM elixir

# Setting up working directory in docker container
WORKDIR /app

# Copy everything from this folder to docker container
COPY . .

# Install hex package manager
RUN mix local.hex --force

# Install dependencies
RUN mix deps.get

# Run application
CMD mix run --no-halt