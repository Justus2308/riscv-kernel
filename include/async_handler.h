#pragma once

extern const void (*async_handler[16])(void);

extern const char* async_info[16];


extern void trap_handle_contained(void);

extern void trap_handle_requested(void);

extern void trap_handle_invisible(void);

extern void trap_handle_fatal(void);
