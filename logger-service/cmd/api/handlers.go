package main

import (
	"log-service/data"
	"net/http"
)

type JSONPayload struct {
	Name string `json:"name"`
	Data string `json:"data"`
}

func (app *Config) WriteLog(w http.ResponseWriter, r *http.Request) {
	// read json into var
	var reqPayload JSONPayload
	err := app.readJSON(w, r, &reqPayload)
	if err != nil {
		app.errorJSON(w, err, http.StatusBadRequest)
		return
	}

	// insert data
	event := data.LogEntry{
		Name: reqPayload.Name,
		Data: reqPayload.Data,
	}
	err = app.Models.LogEntry.Insert(event)
	if err != nil {
		app.errorJSON(w, err)
		return
	}
	resp := jsonResponse{
		Error:   false,
		Message: "logged",
	}
	app.writeJSON(w, http.StatusAccepted, resp)
}
