package com.noteApp.basicNoteApp.entity;

import jakarta.persistence.*;
import jakarta.validation.constraints.Size;
import lombok.Data;
import java.time.LocalDateTime;
import jakarta.validation.constraints.NotBlank;

@Entity
@Table(name = "notes")
@Data
public class note {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Size(min = 3, max = 255, message = "Title en az 3 ve en fazla 255 karakterden oluşmalıdır")
    @NotBlank(message = "Title cannot be empty")
    private String title;

    @NotBlank(message = "Content cannot be empty")
    @Column(columnDefinition = "TEXT")
    private String content;

    private LocalDateTime date;




}
