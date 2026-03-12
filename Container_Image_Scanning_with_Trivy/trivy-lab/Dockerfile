FROM busybox:latest

RUN mkdir -p /myapp
WORKDIR /myapp
RUN echo "Hello from Trivy lab." > sample.txt

RUN adduser -D -u 1000 appuser
USER appuser

CMD ["sh"]
