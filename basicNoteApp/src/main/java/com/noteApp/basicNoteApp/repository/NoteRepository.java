package com.noteApp.basicNoteApp.repository;

import com.noteApp.basicNoteApp.entity.note;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.JpaRepository;

@Repository
public interface NoteRepository extends JpaRepository<note, Long>{
}
