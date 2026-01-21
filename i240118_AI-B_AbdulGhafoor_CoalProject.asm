INCLUDE Irvine32.inc

INCLUDELIB winmm.lib
PlaySound PROTO STDCALL :PTR BYTE, :DWORD, :DWORD 
MODE_ASYNC = 00000001h
MODE_FILENAME = 00020000h

max_len = 20

.data
    ; audio assets
    wav_select BYTE "select.wav", 0
    wav_get BYTE "pickup.wav", 0
    wav_put BYTE "drop.wav", 0
    wav_hit BYTE "crash.wav", 0
    wav_end BYTE "gameover.wav", 0

    ; menu interface strings
    txt_header BYTE "================ RUSH HOUR TAXI ================", 0
    opt_new BYTE "1. Start New Game", 0
    opt_cont BYTE "2. Continue Game", 0
    opt_mode BYTE "3. Select Game Mode", 0 
    opt_leader BYTE "4. View Leaderboard", 0
    opt_help BYTE "5. Read Instructions", 0
    opt_quit BYTE "ESC. Exit", 0
    txt_prompt BYTE "Choose an option: ", 0
    
    ; mode selection
    txt_mode_head BYTE "--- SELECT GAME MODE ---", 0
    txt_m1 BYTE "1. Career Mode (Standard)", 0
    txt_m2 BYTE "2. Time Mode (60 Seconds)", 0
    txt_m3 BYTE "3. Endless Mode", 0
    txt_cur_mode BYTE "Current Mode: ", 0
    
    m_name_1 BYTE "Career", 0
    m_name_2 BYTE "Time  ", 0
    m_name_3 BYTE "Endless", 0

    ; taxi selection strings
    txt_taxi_head BYTE "--- SELECT YOUR TAXI ---", 0
    txt_t1 BYTE "1. Yellow Taxi (Fast, High Penalty)", 0 
    txt_t2 BYTE "2. Red Taxi (Slow, Low Penalty)", 0    
    txt_t3 BYTE "3. Random Selection", 0

    ; player data inputs
    txt_ask_name BYTE "Enter your Name (Max 20 chars): ", 0
    player_name BYTE max_len DUP(0)
    input_buffer BYTE max_len DUP(0)   
    txt_driver BYTE "Driver: ", 0

    txt_top10 BYTE "====== TOP 10 LEADERBOARD ======", 0

    ; instruction text
    txt_help_head BYTE "--- INSTRUCTIONS ---", 0
    help_1 BYTE "1. You are the TAXI (Yellow or Red).", 0
    help_2 BYTE "2. Use ARROW KEYS to move.", 0
    help_3 BYTE "3. Pick up Passengers (Waving '\o') using SPACEBAR.", 0
    help_4 BYTE "4. Drop them at the RED Destination using SPACEBAR.", 0
    help_5 BYTE "5. Collect BONUS GEMS ('<>') for extra points!", 0
    help_6 BYTE "6. Avoid CRASHES! (Trees, Cars, People cause penalty).", 0
    help_7 BYTE "7. Game Over if Score drops below 0!", 0
    txt_ret BYTE "Press any key to return...", 0

    ; game status messages
    txt_pause BYTE "      GAME PAUSED      ", 0
    txt_resume BYTE "   Press 'P' to Resume ", 0
    txt_over BYTE "      GAME OVER!      ", 0
    reason_time BYTE "      (Time Limit Reached)      ", 0
    reason_pts BYTE "      (Score Below Zero!)       ", 0
    txt_final BYTE "      Final Score: ", 0
    passengers_dropped DWORD 0
    game_won BYTE 0
    txt_win BYTE "      YOU WIN!      ", 0
    reason_win BYTE "   All Passengers Delivered!   ", 0
    txt_esc BYTE "   Press ESC to Exit to Menu  ", 0

    txt_wip BYTE "Feature not implemented now!", 0
    txt_any BYTE "Press any key to return...", 0

    ; 20x20 board layout (0=road, 1=building)
    city_layout BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                BYTE 0,1,1,0,0,0,1,1,1,0,0,0,0,1,0,0,1,1,1,0
                BYTE 0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0
                BYTE 0,1,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0
                BYTE 0,0,0,0,1,0,0,1,0,0,0,1,1,1,0,0,1,0,0,0
                BYTE 0,1,1,0,1,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0
                BYTE 0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,0 
                BYTE 0,1,0,0,0,1,1,1,0,0,0,0,0,1,0,0,0,0,0,0
                BYTE 0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1,0,0,0,0
                BYTE 0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                BYTE 0,1,1,1,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0 
                BYTE 0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,1,0,0,0,0
                BYTE 0,0,0,0,0,0,0,0,1,0,0,1,1,0,0,1,1,1,1,0 
                BYTE 0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                BYTE 0,0,1,0,0,1,1,1,0,0,0,0,0,0,1,0,0,0,0,0 
                BYTE 0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0
                BYTE 0,0,0,0,0,1,0,0,0,0,1,1,0,0,1,1,1,1,0,0 
                BYTE 1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0
                BYTE 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,1,1,0
                BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    grid_rows DWORD 20
    grid_cols DWORD 20

    ; taxi coordinates
    taxi_col BYTE 0
    taxi_row BYTE 0
    target_col BYTE 0
    target_row BYTE 0
    taxi_dir BYTE 3 ; 0=Up, 1=Down, 2=Left, 3=Right

    passenger_onboard BYTE 0 

    current_score SDWORD 0
    txt_score_lbl BYTE "Score: ", 0

    ; destination logic
    drop_col BYTE 0
    drop_row BYTE 0
    drop_active BYTE 0 

    ; passenger management
    max_ppl = 5
    ppl_cols BYTE max_ppl DUP(0)
    ppl_rows BYTE max_ppl DUP(0)
    ppl_states BYTE max_ppl DUP(0) 
    total_ppl DWORD 0

    ; npc traffic
    max_traffic = 6
    traf_cols BYTE max_traffic DUP(0)
    traf_rows BYTE max_traffic DUP(0)
    traf_dirs BYTE max_traffic DUP(0)

    ; bonus gems
    max_gems = 6
    gem_cols BYTE max_gems DUP(0)
    gem_rows BYTE max_gems DUP(0)
    gem_active BYTE max_gems DUP(0) 

    ; game settings
    current_mode BYTE 0   
    seconds_remain DWORD 60 
    time_counter DWORD 0  
    loop_delay DWORD 100 
    base_delay DWORD 100 
    drop_count DWORD 0  
    txt_time_lbl BYTE "Time: ", 0

    ; color constants for irvine
    c_road = (15 * 16) + 0
    c_building = (0 * 16)  + 0
    c_person = (15 * 16) + 0 
    c_dest = (4 * 16)  + 15
    c_ui = (0 * 16)  + 14
    c_tree = (10 * 16) + 6
    c_car = (1 * 16)  + 0
    c_pause = (4 * 16)  + 14 
    c_gem = (15 * 16) + 5 

    taxi_color_attr DWORD 0 
    c_yellow_taxi = (6 * 16) + 0   
    c_red_taxi = (4 * 16) + 0   
    c_lights = (12 * 16) + 0 

.code
main PROC
    call Randomize
    
show_menu:
    call Clrscr
    
    mov dl, 20
    mov dh, 5
    call Gotoxy
    mov eax, (1 * 16) + 14
    call SetTextColor
    mov edx, OFFSET txt_header
    call WriteString

    mov eax, (0 * 16) + 7
    call SetTextColor
    
    ; drawing menu options manually
    mov dl, 25
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET opt_new
    call WriteString
    mov dl, 25
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET opt_cont
    call WriteString
    mov dl, 25
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET opt_mode 
    call WriteString
    mov dl, 25
    mov dh, 14
    call Gotoxy
    mov edx, OFFSET opt_leader 
    call WriteString
    mov dl, 25
    mov dh, 16
    call Gotoxy
    mov edx, OFFSET opt_help
    call WriteString
    mov dl, 25
    mov dh, 18
    call Gotoxy
    mov edx, OFFSET opt_quit
    call WriteString
    mov dl, 25
    mov dh, 20
    call Gotoxy
    mov edx, OFFSET txt_prompt
    call WriteString
    
    mov dl, 25
    mov dh, 22
    mov edx, OFFSET txt_cur_mode
    call WriteString
    
    ; check which mode is active to display
    cmp current_mode, 0
    je show_career
    cmp current_mode, 1
    je show_time
    jmp show_endless

show_career:
    mov edx, OFFSET m_name_1
    jmp print_mode_name
show_time:
    mov edx, OFFSET m_name_2
    jmp print_mode_name
show_endless:
    mov edx, OFFSET m_name_3

print_mode_name:
    call WriteString

    call ReadChar
    push eax
    mov edx, OFFSET wav_select
    call play_audio
    pop eax
    
    cmp al, '1'
    je select_taxi_color
    cmp al, '2'
    je screen_wip       
    cmp al, '3'
    je select_game_mode 
    cmp al, '4'
    je screen_leaderboard       
    cmp al, '5'
    je screen_instructions
    cmp al, 27
    je terminate_app
    
    jmp show_menu

select_game_mode:
    call Clrscr
    mov dl, 20
    mov dh, 5
    call Gotoxy
    mov eax, (1 * 16) + 14
    call SetTextColor
    mov edx, OFFSET txt_mode_head
    call WriteString
    mov eax, (0 * 16) + 7
    call SetTextColor
    mov dl, 25
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET txt_m1
    call WriteString
    mov dl, 25
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET txt_m2
    call WriteString
    mov dl, 25
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET txt_m3
    call WriteString
    mov dl, 25
    mov dh, 15
    call Gotoxy
    mov edx, OFFSET txt_prompt
    call WriteString
    
    call ReadChar
    push eax
    mov edx, OFFSET wav_select
    call play_audio
    pop eax
    
    cmp al, '1'
    je set_career
    cmp al, '2'
    je set_time
    cmp al, '3'
    je set_endless
    jmp select_game_mode 

set_career:
    mov current_mode, 0
    jmp show_menu
set_time:
    mov current_mode, 1
    jmp show_menu
set_endless:
    mov current_mode, 2
    jmp show_menu

select_taxi_color:
    call Clrscr
    mov dl, 20
    mov dh, 5
    call Gotoxy
    mov eax, (1 * 16) + 14
    call SetTextColor
    mov edx, OFFSET txt_taxi_head
    call WriteString
    mov eax, (0 * 16) + 7
    call SetTextColor
    mov dl, 25
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET txt_t1
    call WriteString
    mov dl, 25
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET txt_t2
    call WriteString
    mov dl, 25
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET txt_t3
    call WriteString
    mov dl, 25
    mov dh, 15
    call Gotoxy
    mov edx, OFFSET txt_prompt
    call WriteString
    
    call ReadChar
    push eax
    mov edx, OFFSET wav_select
    call play_audio
    pop eax
    
    cmp al, '1'
    je pick_yellow
    cmp al, '2'
    je pick_red
    cmp al, '3'
    je pick_random
    jmp select_taxi_color 

pick_yellow:
    mov taxi_color_attr, c_yellow_taxi
    mov base_delay, 80   ; yellow is faster
    jmp enter_name
pick_red:
    mov taxi_color_attr, c_red_taxi
    mov base_delay, 120  ; red is slower
    jmp enter_name
pick_random:
    mov eax, 2      
    call RandomRange
    cmp eax, 0
    je pick_yellow
    jmp pick_red

enter_name:
    call Clrscr
    mov eax, (0 * 16) + 15 
    call SetTextColor
    mov dl, 20
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET txt_ask_name
    call WriteString
    
    ; clear name buffer memory
    mov ecx, max_len
    mov edi, OFFSET player_name
    mov al, 0        
    rep stosb
    
    mov edx, OFFSET input_buffer
    mov ecx, max_len
    call ReadString
    
    mov esi, OFFSET input_buffer
    mov edi, OFFSET player_name
    mov ecx, max_len
copy_name_loop:
    mov al, [esi]
    cmp al, 0
    je finish_name
    mov [edi], al
    inc esi
    inc edi
    loop copy_name_loop
finish_name:
    mov byte ptr [edi], 0 
    jmp init_game

init_game:
    call Clrscr
    mov taxi_col, 0
    mov taxi_row, 0
    mov current_score, 0
    mov passenger_onboard, 0
    mov passengers_dropped, 0
    mov game_won, 0
    mov drop_active, 0
    mov seconds_remain, 60       
    mov time_counter, 0
    mov drop_count, 0
    mov taxi_dir, 3     ; face right initially
    mov eax, base_delay
    mov loop_delay, eax
    
    call clear_map_obstacles
    call spawn_trees
    call render_grid
    call spawn_traffic
    call spawn_people
    call spawn_gems 
    call render_traffic
    call render_people
    call render_gems
    call render_taxi
    call update_ui

active_game_loop:
    cmp game_won, 1
    je game_win_screen
    mov eax, loop_delay
    call Delay
    
    ; handle timer for time mode
    cmp current_mode, 1     
    jne skip_timer_logic
    mov eax, loop_delay
    add time_counter, eax
    cmp time_counter, 1000
    jl skip_timer_logic
    sub time_counter, 1000 
    dec seconds_remain
    call update_ui 
    cmp seconds_remain, 0
    je game_over_time
    
skip_timer_logic:
    call ReadKey      
    jz update_entities      
    
    cmp al, 'p'
    je trigger_pause
    cmp al, 'P'
    je trigger_pause
    
    ; directional inputs
    cmp ah, 48h     
    je move_up_intent
    cmp ah, 50h     
    je move_down_intent
    cmp ah, 4Bh     
    je move_left_intent
    cmp ah, 4Dh     
    je move_right_intent
    
    cmp al, 20h     ; spacebar
    je interact_action
    cmp al, 27      
    je ret_to_menu
    jmp update_entities     

trigger_pause:
    mov dl, 12
    mov dh, 9
    call Gotoxy
    mov eax, c_pause
    call SetTextColor
    mov edx, OFFSET txt_pause
    call WriteString
    mov dl, 12
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET txt_resume
    call WriteString
wait_resume:
    call ReadChar 
    cmp al, 'p'
    je resume_game
    cmp al, 'P'
    je resume_game
    jmp wait_resume
resume_game:
    call render_grid
    call render_traffic
    call render_people
    call render_gems
    call render_drop_zone
    call render_taxi
    jmp active_game_loop

ret_to_menu:
    jmp show_menu

interact_action:
    call handle_spacebar
    jmp update_entities

; set proposed coordinates based on input
move_up_intent:
    mov taxi_dir, 0    
    mov bl, taxi_col
    mov target_col, bl
    mov bl, taxi_row
    dec bl
    mov target_row, bl
    jmp validate_move
move_down_intent:
    mov taxi_dir, 1    
    mov bl, taxi_col
    mov target_col, bl
    mov bl, taxi_row
    inc bl
    mov target_row, bl
    jmp validate_move
move_left_intent:
    mov taxi_dir, 2    
    mov bl, taxi_col
    dec bl
    mov target_col, bl
    mov bl, taxi_row
    mov target_row, bl
    jmp validate_move
move_right_intent:
    mov taxi_dir, 3    
    mov bl, taxi_col
    inc bl
    mov target_col, bl
    mov bl, taxi_row
    mov target_row, bl
    jmp validate_move

validate_move:
    ; boundary checks
    cmp target_col, 0
    jl update_entities
    cmp target_col, 19
    jg update_entities
    cmp target_row, 0
    jl update_entities
    cmp target_row, 19
    jg update_entities
    
    ; check static map objects
    movzx eax, target_row
    imul eax, 20
    movzx ebx, target_col
    add eax, ebx
    cmp city_layout[eax], 2  
    je collision_tree
    cmp city_layout[eax], 1  
    je update_entities          
    
    ; check dynamic traffic
    push ecx
    mov esi, 0
    mov ecx, max_traffic
check_npc_collision:
    mov al, target_col
    cmp al, traf_cols[esi]
    jne safe_npc_chk
    mov al, target_row
    cmp al, traf_rows[esi]
    je collision_car
safe_npc_chk:
    inc esi
    loop check_npc_collision
    pop ecx
    
    ; check passenger collision (only if they are waving)
    push ecx
    mov esi, 0
    mov ecx, total_ppl
check_ppl_crash:
    cmp ppl_states[esi], 1 
    jne safe_ppl_chk
    cmp passenger_onboard, 0
    je safe_ppl_chk   ; can't crash if empty, might be picking up
    mov al, target_col
    cmp al, ppl_cols[esi]
    jne safe_ppl_chk
    mov al, target_row
    cmp al, ppl_rows[esi]
    je collision_person
safe_ppl_chk:
    inc esi
    loop check_ppl_crash
    pop ecx
    
    ; valid move: update position
    call clear_taxi_pos
    mov bl, target_col
    mov taxi_col, bl
    mov bl, target_row
    mov taxi_row, bl
    call check_gem_pickup
    jmp update_entities

collision_tree:
    mov edx, OFFSET wav_hit
    call play_audio
    cmp taxi_color_attr, c_red_taxi
    je pen_red_tree
    sub current_score, 4 ; yellow taxi penalty
    jmp check_survival
pen_red_tree:
    sub current_score, 2 ; red taxi penalty
    jmp check_survival

collision_car:
    pop ecx
    mov edx, OFFSET wav_hit
    call play_audio
    cmp taxi_color_attr, c_red_taxi
    je pen_red_car
    sub current_score, 2 ; yellow taxi penalty
    jmp check_survival
pen_red_car:
    sub current_score, 3 ; red taxi penalty
    jmp check_survival

collision_person:
    pop ecx 
    mov edx, OFFSET wav_hit
    call play_audio
    sub current_score, 5 ; universal penalty
    jmp check_survival

check_survival:
    call update_ui
    cmp current_score, 0
    jl game_over_crash   
    jmp update_entities         

update_entities:
    call move_traffic
    call render_traffic
    call render_drop_zone
    call render_people
    call render_gems 
    call render_taxi     
    jmp active_game_loop

game_over_time:
    call Clrscr
    mov edx, OFFSET wav_end
    call play_audio
    mov dl, 10
    mov dh, 8
    call Gotoxy
    mov eax, c_pause 
    call SetTextColor
    mov edx, OFFSET txt_over
    call WriteString
    mov dl, 10
    mov dh, 9
    mov edx, OFFSET reason_time
    call WriteString
    jmp display_final_score

game_over_crash:
    call Clrscr
    mov edx, OFFSET wav_end
    call play_audio
    mov dl, 10
    mov dh, 8
    call Gotoxy
    mov eax, c_pause 
    call SetTextColor
    mov edx, OFFSET txt_over
    call WriteString
    mov dl, 10
    mov dh, 9
    mov edx, OFFSET reason_pts
    call WriteString
    jmp display_final_score

game_win_screen:
    call Clrscr
    mov edx, OFFSET wav_select
    call play_audio

    mov dl, 10
    mov dh, 8
    call Gotoxy
    mov eax, (2 * 16) + 15 ; Green background with white text
    call SetTextColor
    mov edx, OFFSET txt_win
    call WriteString

    mov dl, 10
    mov dh, 9
    mov edx, OFFSET reason_win
    call WriteString
    jmp display_final_score

display_final_score:
    mov dl, 10
    mov dh, 11
    call Gotoxy
    mov eax, (0 * 16) + 15 
    call SetTextColor
    mov edx, OFFSET txt_final
    call WriteString
    mov eax, current_score
    call WriteInt  
    mov dl, 10
    mov dh, 13
    call Gotoxy
    mov edx, OFFSET txt_esc
    call WriteString
wait_exit_input:
    call ReadChar
    cmp al, 27 
    jne wait_exit_input
    jmp show_menu

screen_instructions:
    call Clrscr
    mov eax, (0 * 16) + 15
    call SetTextColor
    mov dl, 20
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET txt_help_head
    call WriteString
    mov dl, 10
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET help_1
    call WriteString
    mov dl, 10
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET help_2
    call WriteString
    mov dl, 10
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET help_3
    call WriteString
    mov dl, 10
    mov dh, 14
    call Gotoxy
    mov edx, OFFSET help_4
    call WriteString
    mov dl, 10
    mov dh, 16
    call Gotoxy
    mov edx, OFFSET help_5
    call WriteString
    mov dl, 10
    mov dh, 18
    call Gotoxy
    mov edx, OFFSET help_6
    call WriteString
    mov dl, 10
    mov dh, 20
    call Gotoxy
    mov edx, OFFSET help_7
    call WriteString
    mov dl, 20
    mov dh, 22
    call Gotoxy
    mov edx, OFFSET txt_ret
    call WriteString
    call ReadChar
    jmp show_menu

screen_wip:
    call Clrscr
    mov eax, (0 * 16) + 15
    call SetTextColor
    mov dl, 20
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET txt_wip  
    call WriteString
    mov dl, 20
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET txt_any
    call WriteString
    call ReadChar
    jmp show_menu

screen_leaderboard:
    call Clrscr
    mov eax, (1 * 16) + 15 
    call SetTextColor
    mov dl, 20
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET txt_top10
    call WriteString
    
    mov dl, 20
    mov dh, 10
    mov eax, (0 * 16) + 15
    call SetTextColor
    mov edx, OFFSET txt_wip   
    call WriteString
    
    mov dl, 20
    mov dh, 22
    call Gotoxy
    mov edx, OFFSET txt_any
    call WriteString
    call ReadChar
    jmp show_menu

terminate_app:
    mov eax, (0 * 16) + 15
    call SetTextColor
    call Clrscr
    exit
main ENDP

; Procedures

handle_spacebar PROC
    cmp passenger_onboard, 0
    je try_pickup_logic
    call try_dropoff_logic
    ret
try_pickup_logic:
    call try_pickup_func
    ret
handle_spacebar ENDP

try_dropoff_logic PROC uses eax ecx edx
    cmp drop_active, 0
    je fail_drop
    
    ; check adjacency to drop zone
    mov al, taxi_col
    cmp al, drop_col
    jne check_right
    mov al, taxi_row
    cmp al, drop_row
    je success_drop
check_right:
    mov al, taxi_col
    inc al
    cmp al, drop_col
    jne check_left
    mov al, taxi_row
    cmp al, drop_row
    je success_drop
check_left:
    mov al, taxi_col
    dec al
    cmp al, drop_col
    jne check_down
    mov al, taxi_row
    cmp al, drop_row
    je success_drop
check_down:
    mov al, taxi_row
    inc al
    cmp al, drop_row
    jne check_up
    mov al, taxi_col
    cmp al, drop_col
    je success_drop
check_up:
    mov al, taxi_row
    dec al
    cmp al, drop_row
    jne fail_drop
    mov al, taxi_col
    cmp al, drop_col
    je success_drop
    jmp fail_drop

success_drop:
    add current_score, 10
    inc passengers_dropped

    mov eax, passengers_dropped
    cmp eax, total_ppl
    jne continue_drop_logic

    cmp current_mode, 2
    je continue_drop_logic

    mov game_won, 1

continue_drop_logic:
    call update_ui
    mov edx, OFFSET wav_put
    call play_audio

    mov passenger_onboard, 0
    mov drop_active, 0
    
    ; clear drop zone visually
    mov dl, drop_col
    shl dl, 1
    mov dh, drop_row
    call Gotoxy
    mov eax, c_road
    call SetTextColor
    mov al, ' '
    call WriteChar
    call WriteChar
    
    ; increase difficulty every 2 drops
    inc drop_count
    mov edx, 0
    mov eax, drop_count
    mov ecx, 2
    div ecx
    cmp edx, 0          
    jne fail_drop
    cmp loop_delay, 20   
    jle fail_drop
    sub loop_delay, 10   
fail_drop:
    ret
try_dropoff_logic ENDP

clear_map_obstacles PROC uses eax ecx esi
    mov ecx, 400        
    mov esi, 0
clr_loop:
    cmp city_layout[esi], 2 
    jne next_byte
    mov city_layout[esi], 0 
next_byte:
    inc esi
    loop clr_loop
    ret
clear_map_obstacles ENDP

spawn_trees PROC uses eax ebx ecx
    mov ecx, 6          
tree_loop:
    mov eax, 20
    call RandomRange
    mov bl, al
    mov eax, 20
    call RandomRange
    mov bh, al
    movzx eax, bh
    imul eax, 20
    movzx edx, bl
    add eax, edx
    cmp city_layout[eax], 0
    jne tree_loop
    cmp bl, 0
    jne place_tree_byte
    cmp bh, 0
    je  tree_loop
place_tree_byte:
    mov city_layout[eax], 2 
    loop tree_loop
    ret
spawn_trees ENDP

spawn_traffic PROC uses eax ebx ecx edi
    mov ecx, max_traffic
    mov edi, 0
traf_gen_loop:
    mov eax, 20
    call RandomRange
    mov bl, al
    mov eax, 20
    call RandomRange
    mov bh, al
    movzx eax, bh
    imul eax, 20
    movzx edx, bl
    add eax, edx
    cmp city_layout[eax], 0
    jne traf_gen_loop
    cmp bl, 0
    jne finalize_car
    cmp bh, 0
    je traf_gen_loop
finalize_car:
    mov traf_cols[edi], bl
    mov traf_rows[edi], bh
    mov eax, 4
    call RandomRange
    mov traf_dirs[edi], al
    inc edi
    loop traf_gen_loop
    ret
spawn_traffic ENDP

spawn_gems PROC uses eax ebx ecx edi
    mov ecx, max_gems
    mov edi, 0
gem_gen_loop:
    mov eax, 20
    call RandomRange
    mov bl, al
    mov eax, 20
    call RandomRange
    mov bh, al
    movzx eax, bh
    imul eax, 20
    movzx edx, bl
    add eax, edx
    cmp city_layout[eax], 0
    jne gem_gen_loop
    cmp bl, 0
    jne finalize_gem
    cmp bh, 0
    je  gem_gen_loop
finalize_gem:
    mov gem_cols[edi], bl
    mov gem_rows[edi], bh
    mov gem_active[edi], 1
    inc edi
    loop gem_gen_loop
    ret
spawn_gems ENDP

check_gem_pickup PROC uses eax ecx edi
    mov ecx, max_gems
    mov edi, 0
chk_gem_loop:
    cmp gem_active[edi], 1
    jne skip_gem
    mov al, gem_cols[edi]
    cmp al, taxi_col
    jne skip_gem
    mov al, gem_rows[edi]
    cmp al, taxi_row
    jne skip_gem
    
    add current_score, 10
    mov gem_active[edi], 0 
    call update_ui
skip_gem:
    inc edi
    loop chk_gem_loop
    ret
check_gem_pickup ENDP

render_gems PROC uses eax ecx edx edi
    mov ecx, max_gems
    mov edi, 0
draw_gem_loop:
    cmp gem_active[edi], 1
    jne next_gem_gfx
    mov al, gem_cols[edi]
    cmp al, taxi_col
    jne print_gem
    mov al, gem_rows[edi]
    cmp al, taxi_row
    je  next_gem_gfx
print_gem:
    mov dl, gem_cols[edi]
    shl dl, 1
    mov dh, gem_rows[edi]
    call Gotoxy
    mov eax, c_gem
    call SetTextColor
    mov al, '<'        
    call WriteChar
    mov al, '>'
    call WriteChar
next_gem_gfx:
    inc edi
    loop draw_gem_loop
    ret
render_gems ENDP

move_traffic PROC uses eax ebx ecx edx edi esi
    mov edi, 0
    mov ecx, max_traffic
move_cars_loop:
    ; erase old position
    mov dl, traf_cols[edi]
    shl dl, 1
    mov dh, traf_rows[edi]
    call Gotoxy
    mov eax, c_road
    call SetTextColor
    mov al, ' '
    call WriteChar
    call WriteChar
    
    mov al, traf_cols[edi]
    mov bl, traf_rows[edi]
    mov target_col, al
    mov target_row, bl
    
    mov al, traf_dirs[edi]
    cmp al, 0
    je try_up_npc
    cmp al, 1
    je try_down_npc
    cmp al, 2
    je try_left_npc
    jmp try_right_npc
try_up_npc:
    dec target_row
    jmp check_npc_crash
try_down_npc:
    inc target_row
    jmp check_npc_crash
try_left_npc:
    dec target_col
    jmp check_npc_crash
try_right_npc:
    inc target_col

check_npc_crash:
    ; boundary checks
    cmp target_col, 0
    jl reverse_npc
    cmp target_col, 19
    jg reverse_npc
    cmp target_row, 0
    jl reverse_npc
    cmp target_row, 19
    jg reverse_npc
    
    ; object checks
    movzx eax, target_row
    imul eax, 20
    movzx ebx, target_col
    add eax, ebx
    cmp city_layout[eax], 0
    jne reverse_npc
    
    ; player check
    mov al, target_col
    cmp al, taxi_col
    jne check_other_npcs
    mov al, target_row
    cmp al, taxi_row
    je reverse_npc

check_other_npcs:
    push ecx
    mov esi, 0
    mov ecx, max_traffic
inner_npc_loop:
    cmp esi, edi
    je skip_self
    mov al, target_col
    cmp al, traf_cols[esi]
    jne skip_self
    mov al, target_row
    cmp al, traf_rows[esi]
    je npc_collision_found
skip_self:
    inc esi
    loop inner_npc_loop
    pop ecx
    jmp check_ppl_overlap

npc_collision_found:
    pop ecx
    jmp reverse_npc

check_ppl_overlap:
    push ecx
    mov esi, 0
    mov ecx, total_ppl
ppl_overlap_loop:
    cmp ppl_states[esi], 1
    jne no_ppl_issue
    mov al, target_col
    cmp al, ppl_cols[esi]
    jne no_ppl_issue
    mov al, target_row
    cmp al, ppl_rows[esi]
    je npc_hit_ppl
no_ppl_issue:
    inc esi
    loop ppl_overlap_loop
    pop ecx
    jmp confirm_npc_move

npc_hit_ppl:
    pop ecx
    jmp reverse_npc

confirm_npc_move:
    mov al, target_col
    mov traf_cols[edi], al
    mov al, target_row
    mov traf_rows[edi], al
    jmp next_npc_iter

reverse_npc:
    ; pick random new direction if blocked
    mov eax, 4
    call RandomRange
    mov traf_dirs[edi], al
next_npc_iter:
    inc edi
    dec ecx
    jnz move_cars_loop
    ret
move_traffic ENDP

try_pickup_func PROC uses eax ecx edx esi
    mov ecx, total_ppl
    mov esi, 0
scan_ppl:
    cmp ppl_states[esi], 1
    jne next_ppl_chk
    
    mov bl, ppl_cols[esi]
    mov bh, ppl_rows[esi]
    
    ; check all 4 sides
    mov al, taxi_col
    cmp al, bl
    jne chk_r
    mov al, taxi_row
    cmp al, bh
    je do_pickup
chk_r:
    mov al, taxi_col
    inc al
    cmp al, bl
    jne chk_l
    mov al, taxi_row
    cmp al, bh
    je do_pickup
chk_l:
    mov al, taxi_col
    dec al
    cmp al, bl
    jne chk_d
    mov al, taxi_row
    cmp al, bh
    je do_pickup
chk_d:
    mov al, taxi_row
    inc al
    cmp al, bh
    jne chk_u
    mov al, taxi_col
    cmp al, bl
    je do_pickup
chk_u:
    mov al, taxi_row
    dec al
    cmp al, bh
    jne next_ppl_chk
    mov al, taxi_col
    cmp al, bl
    je do_pickup
next_ppl_chk:
    inc esi
    loop scan_ppl
    ret

do_pickup:
    mov ppl_states[esi], 2   
    mov passenger_onboard, 1        
    mov edx, OFFSET wav_get
    call play_audio
    
    ; erase passenger from map
    mov dl, ppl_cols[esi]
    shl dl, 1
    mov dh, ppl_rows[esi]
    call Gotoxy
    mov eax, c_road
    call SetTextColor
    mov al, ' '
    call WriteChar
    call WriteChar
    
    call create_new_dropoff
    call render_drop_zone
    ret
try_pickup_func ENDP

create_new_dropoff PROC uses eax ebx
gen_dest_loop:
    mov eax, 20
    call RandomRange
    mov drop_col, al
    mov eax, 20
    call RandomRange
    mov drop_row, al
    
    movzx eax, drop_row
    imul eax, 20
    movzx ebx, drop_col
    add eax, ebx
    cmp city_layout[eax], 0
    jne gen_dest_loop     
    
    ; ensure not spawning on top of player
    mov al, drop_col
    cmp al, taxi_col
    jne final_dest
    mov al, drop_row
    cmp al, taxi_row
    je gen_dest_loop
final_dest:
    mov drop_active, 1
    ret
create_new_dropoff ENDP

render_drop_zone PROC uses eax edx
    cmp drop_active, 1
    jne skip_dest_render
    mov al, drop_col
    cmp al, taxi_col
    jne draw_dest
    mov al, drop_row
    cmp al, taxi_row
    je skip_dest_render
draw_dest:
    mov dl, drop_col
    shl dl, 1
    mov dh, drop_row
    call Gotoxy
    mov eax, c_dest
    call SetTextColor
    mov al, ' '    
    call WriteChar
    call WriteChar
skip_dest_render:
    ret
render_drop_zone ENDP

update_ui PROC uses eax edx
    mov eax, c_ui
    call SetTextColor
    mov dl, 45
    mov dh, 1
    call Gotoxy
    mov edx, OFFSET txt_driver
    call WriteString
    mov edx, OFFSET player_name
    call WriteString
    mov dl, 45
    mov dh, 3
    call Gotoxy
    mov edx, OFFSET txt_score_lbl
    call WriteString
    mov eax, current_score
    call WriteInt  
    mov al, ' '
    call WriteChar
    call WriteChar
    
    cmp current_mode, 1
    jne skip_time_ui
    mov dl, 45
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET txt_time_lbl
    call WriteString
    mov eax, seconds_remain
    call WriteDec
    mov al, ' '
    call WriteChar
skip_time_ui:
    ret
update_ui ENDP

spawn_people PROC uses eax ebx ecx edx esi
    mov eax, 3
    call RandomRange
    add eax, 3
    mov total_ppl, eax
    mov ecx, total_ppl
    mov esi, 0
ppl_loop_outer:
retry_ppl_pos:
    mov eax, 20
    call RandomRange
    mov ppl_cols[esi], al
    mov eax, 20
    call RandomRange
    mov ppl_rows[esi], al
    
    movzx eax, ppl_rows[esi]
    imul eax, 20
    movzx ebx, ppl_cols[esi]
    add eax, ebx
    cmp city_layout[eax], 0 
    jne retry_ppl_pos        
    
    cmp ppl_cols[esi], 0
    jne ok_ppl
    cmp ppl_rows[esi], 0
    je retry_ppl_pos
ok_ppl:
    mov ppl_states[esi], 1 
    inc esi
    loop ppl_loop_outer
    ret
spawn_people ENDP

render_people PROC uses eax ecx edx esi
    mov ecx, total_ppl
    mov esi, 0
draw_ppl_loop:
    cmp ppl_states[esi], 1
    jne skip_ppl_render
    mov al, ppl_cols[esi]
    cmp al, taxi_col
    jne do_draw_ppl
    mov al, taxi_row
    cmp al, ppl_rows[esi]
    je skip_ppl_render
do_draw_ppl:
    mov dl, ppl_cols[esi]
    shl dl, 1
    mov dh, ppl_rows[esi]
    call Gotoxy
    mov eax, c_person
    call SetTextColor
    
    mov al, '\'     
    call WriteChar
    mov al, 'o'     
    call WriteChar
skip_ppl_render:
    inc esi
    loop draw_ppl_loop
    ret
render_people ENDP

render_traffic PROC uses eax ecx edx edi
    mov ecx, max_traffic
    mov edi, 0
car_draw_loop:
    mov al, traf_cols[edi]
    cmp al, taxi_col
    jne do_render_car
    mov al, traf_rows[edi]
    cmp al, taxi_row
    je next_car_draw
do_render_car:
    ; prevent drawing over passengers
    push ecx
    push edi
    mov esi, 0
    mov ecx, total_ppl
chk_ppl_under_car:
    cmp ppl_states[esi], 1
    jne next_chk_ppl
    mov al, traf_cols[edi]
    cmp al, ppl_cols[esi]
    jne next_chk_ppl
    mov al, traf_rows[edi]
    cmp al, ppl_rows[esi]
    je abort_car_draw
next_chk_ppl:
    inc esi
    loop chk_ppl_under_car
    pop edi
    pop ecx
    jmp draw_car_gfx
abort_car_draw:
    pop edi
    pop ecx
    jmp next_car_draw

draw_car_gfx:
    mov dl, traf_cols[edi]
    shl dl, 1
    mov dh, traf_rows[edi]
    call Gotoxy

    mov al, traf_dirs[edi]
    cmp al, 0
    je draw_up
    cmp al, 1
    je draw_down
    cmp al, 2
    je draw_left
    jmp draw_right

draw_up:
    mov eax, c_car
    call SetTextColor
    mov al, 220
    call WriteChar
    call WriteChar
    jmp next_car_draw

draw_down:
    mov eax, c_lights
    call SetTextColor
    mov al, 220
    call WriteChar
    call WriteChar
    jmp next_car_draw

draw_left:
    mov eax, c_lights
    call SetTextColor
    mov al, 220
    call WriteChar
    mov eax, c_car
    call SetTextColor
    mov al, 220
    call WriteChar
    jmp next_car_draw

draw_right:
    mov eax, c_car
    call SetTextColor
    mov al, 220
    call WriteChar
    mov eax, c_lights
    call SetTextColor
    mov al, 220
    call WriteChar
    jmp next_car_draw

next_car_draw:
    inc edi
    dec ecx
    jnz car_draw_loop
    ret
render_traffic ENDP

render_taxi PROC uses eax edx
    mov dl, taxi_col
    shl dl, 1
    mov dh, taxi_row
    call Gotoxy

    cmp taxi_dir, 0
    je t_up
    cmp taxi_dir, 1
    je t_down
    cmp taxi_dir, 2
    je t_left
    jmp t_right

t_up:
    mov eax, taxi_color_attr
    call SetTextColor
    mov al, 220
    call WriteChar
    call WriteChar
    ret

t_down:
    mov eax, c_lights
    call SetTextColor
    mov al, 220
    call WriteChar
    call WriteChar
    ret

t_left:
    mov eax, c_lights
    call SetTextColor
    mov al, 220
    call WriteChar
    mov eax, taxi_color_attr
    call SetTextColor
    mov al, 220
    call WriteChar
    ret

t_right:
    mov eax, taxi_color_attr
    call SetTextColor
    mov al, 220
    call WriteChar
    mov eax, c_lights
    call SetTextColor
    mov al, 220
    call WriteChar
    ret
render_taxi ENDP

clear_taxi_pos PROC uses eax edx
    mov dl, taxi_col
    shl dl, 1
    mov dh, taxi_row
    call Gotoxy
    mov eax, c_road
    call SetTextColor
    mov al, ' '
    call WriteChar
    call WriteChar
    ret
clear_taxi_pos ENDP

render_grid PROC uses eax ecx edx esi
    mov esi, 0
    mov ecx, grid_rows
    mov dh, 0
row_loop:
    mov dl, 0
    push ecx
    mov ecx, grid_cols
col_loop:
    call Gotoxy
    cmp city_layout[esi], 1
    je draw_bldg
    cmp city_layout[esi], 2
    je draw_tree
draw_road:
    mov eax, c_road
    call SetTextColor
    jmp out_cell
draw_bldg:
    mov eax, c_building
    call SetTextColor
    jmp out_cell

draw_tree:
    mov eax, c_tree
    call SetTextColor
    mov al, 220    
    call WriteChar
    call WriteChar
    jmp next_cell

out_cell:
    mov al, ' '
    call WriteChar
    call WriteChar  
next_cell:
    inc esi
    add dl, 2
    loop col_loop
    inc dh
    pop ecx
    loop row_loop
    ret
render_grid ENDP

play_audio PROC uses eax
    INVOKE PlaySound, edx, 0, MODE_FILENAME OR MODE_ASYNC
    ret
play_audio ENDP

END main