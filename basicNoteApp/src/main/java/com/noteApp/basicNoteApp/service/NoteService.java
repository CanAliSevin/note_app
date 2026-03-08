package com.noteApp.basicNoteApp.service;

import com.noteApp.basicNoteApp.entity.note;
import com.noteApp.basicNoteApp.repository.NoteRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class NoteService {

    private final NoteRepository NoteRepository;



    public note save(note note){
        note.setDate(LocalDateTime.now());
        return NoteRepository.save(note);
    }

    public List<note> findAll(){
        return NoteRepository.findAll();
    }
    public void delete(Long id){
        NoteRepository.deleteById(id);
    }
    public note update(note note){
        return NoteRepository.save(note);
    }


}
