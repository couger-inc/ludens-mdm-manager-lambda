FROM golang:1.24.0 AS builder
WORKDIR /app
ARG BUILD_DIR
ARG HANDLER
COPY ./${BUILD_DIR}/go.mod ./
COPY ./${BUILD_DIR}/go.sum ./
COPY ./${BUILD_DIR}/${HANDLER} ./
RUN go mod tidy
RUN GOOS=linux GOARCH=amd64 go build -C ./ -tags lambda.norpc -o /app/main ${HANDLER}

FROM public.ecr.aws/lambda/provided:al2023
COPY --from=builder /app/main ./main
ENTRYPOINT [ "./main" ]