package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
)

func (app *Config) Authenticate(w http.ResponseWriter, r *http.Request) {
	var reqPayload struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}

	err := app.readJSON(w, r, &reqPayload)
	if err != nil {
		app.errorJSON(w, err, http.StatusBadRequest)
		return
	}
	// validate the user against the database
	user, err := app.Models.User.GetByEmail(reqPayload.Email)
	if err != nil {
		app.errorJSON(w, errors.New("invalid credentials"), http.StatusBadRequest)
		return
	}

	valid, err := user.PasswordMatches(reqPayload.Password)
	if err != nil || !valid {
		app.errorJSON(w, errors.New("invalid credentials"), http.StatusBadRequest)
		return
	}

	// log authentication
	err = app.logRequest("authentication", fmt.Sprintf("%s logged in", user.Email))
	if err != nil {
		app.errorJSON(w, err)
		return
	}

	payload := jsonResponse{
		Error:   false,
		Message: fmt.Sprintf("Logged in user %s", user.Email),
		Data:    user,
	}
	app.writeJSON(w, http.StatusAccepted, payload)
}

func (app *Config) logRequest(name, data string) error {
	var entry struct {
		Name string `json:"name"`
		Data string `json:"data"`
	}

	entry.Name = name
	entry.Data = data
	jsonData, err := json.MarshalIndent(entry, "", "\t")
	if err != nil {
		return err
	}
	logServiceURL := "http://logger-service/log"
	request, err := http.NewRequest("POST", logServiceURL, bytes.NewBuffer(jsonData))
	if err != nil {
		return err
	}

	client := &http.Client{}
	_, err = client.Do(request)
	return err
}
