FROM golang:1.6.2-alpine
COPY . .
WORKDIR .
RUN go build -o go-web .
CMD ["./go-web"]

