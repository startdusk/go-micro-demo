package main

import (
	"context"
	"fmt"
	"log"
	logspb "loggerservice/api/gen/v1"
	"loggerservice/data"
	"net"

	"google.golang.org/grpc"
)

type LogServer struct {
	logspb.UnimplementedLogServiceServer
	Models data.Models
}

func (l *LogServer) WriteLog(ctx context.Context, req *logspb.LogRequest) (*logspb.LogResponse, error) {
	input := req.GetLogEntry()

	// write the log
	logEntry := data.LogEntry{
		Name: input.Name,
		Data: input.Data,
	}

	err := l.Models.LogEntry.Insert(logEntry)
	if err != nil {
		res := &logspb.LogResponse{
			Result: "failed",
		}
		return res, err
	}

	// return response
	res := &logspb.LogResponse{
		Result: "logged",
	}
	return res, nil
}

func (app *Config) gRPCListen() {
	lis, err := net.Listen("tcp", fmt.Sprintf(":%s", gRPCPort))
	if err != nil {
		log.Fatalf("failed to listen for gRPC: %+v", err)
	}

	s := grpc.NewServer()
	logspb.RegisterLogServiceServer(s, &LogServer{Models: app.Models})

	log.Printf("gRPC server started on port: %s", gRPCPort)

	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to listen for gRPC: %+v", err)
	}
}
