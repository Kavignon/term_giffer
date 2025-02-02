FROM debian:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    asciinema \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install agg (asciinema GIF generator)
RUN curl -fL https://github.com/asciinema/agg/releases/download/v1.5.0/agg-aarch64-unknown-linux-gnu -o /usr/local/bin/agg && \
    chmod +x /usr/local/bin/agg

# Set the working directory
WORKDIR /output

# Copy the script into the container
COPY app.sh /usr/local/bin/app
RUN chmod +x /usr/local/bin/app

# Set the default entrypoint
ENTRYPOINT ["app"]
