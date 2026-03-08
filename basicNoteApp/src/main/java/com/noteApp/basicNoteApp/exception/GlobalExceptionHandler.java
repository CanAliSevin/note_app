package com.noteApp.basicNoteApp.exception;


import org.springframework.boot.context.config.ConfigDataResourceNotFoundException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<String> handleMethodArgumentNotValidException(MethodArgumentNotValidException eror) {
        return ResponseEntity.badRequest().body(eror.getMessage());
    }
    @ExceptionHandler(ConfigDataResourceNotFoundException.class)
    public ResponseEntity<String> handleConfigDataResourceNotFoundException(ConfigDataResourceNotFoundException eror) {
        return ResponseEntity.badRequest().body(eror.getMessage());
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<String> handleException(Exception eror) {
        return ResponseEntity.badRequest().body(eror.getMessage());
    }
}
