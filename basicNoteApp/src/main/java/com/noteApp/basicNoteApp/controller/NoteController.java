package com.noteApp.basicNoteApp.controller;

import com.noteApp.basicNoteApp.entity.note;
import com.noteApp.basicNoteApp.service.NoteService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/rest/api/notes")
@RequiredArgsConstructor
@CrossOrigin(origins = "*") // CORS için eklendi
public class NoteController {

    private final NoteService noteService;

    @PostMapping("/save")
    public ResponseEntity<note> create(@Valid @RequestBody note note){
        return ResponseEntity.ok(noteService.save(note));
    }

    @GetMapping("/list")
    public ResponseEntity<List<note>> findAll(){
        return ResponseEntity.ok(noteService.findAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id){
        noteService.delete(id);
        return ResponseEntity.ok().build();
    }
    @PutMapping("/update/{id}")
    public ResponseEntity<note> update(@Valid @RequestBody note note){
        return ResponseEntity.ok(noteService.save(note));
    }
}