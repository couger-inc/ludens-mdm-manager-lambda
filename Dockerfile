FROM public.ecr.aws/docker/library/golang:1.24.2 AS build-image
WORKDIR /src
COPY ./get-managers-lambda/go.mod ./get-managers-lambda/go.sum ./get-managers-lambda/main.go ./
RUN go build -o lambda-handler
FROM public.ecr.aws/lambda/provided:al2
COPY --from=build-image /src/lambda-handler .
ENTRYPOINT ["./lambda-handler"]