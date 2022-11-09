package main

import "log"

type LogWriter struct {
	logger *log.Logger
}

func NewLogWriter(l *log.Logger) *LogWriter {
	lw := &LogWriter{}
	lw.logger = l
	return lw
}

func (lw LogWriter) Write(p []byte) (n int, err error) {
	lw.logger.Print(string(p))
	return len(p), nil
}
