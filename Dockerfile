ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:3.21
FROM ${BUILD_FROM}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apk add --no-cache curl \
    && ARCH="$(apk --print-arch)" \
    && case "${ARCH}" in \
         x86_64) CF_ARCH="amd64" ;; \
         aarch64) CF_ARCH="arm64" ;; \
         armv7) CF_ARCH="arm" ;; \
         armhf) CF_ARCH="arm" ;; \
         x86) CF_ARCH="386" ;; \
         *) echo "Unsupported arch: ${ARCH}" && exit 1 ;; \
       esac \
    && curl -L "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${CF_ARCH}" \
       -o /usr/local/bin/cloudflared \
    && chmod +x /usr/local/bin/cloudflared

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
