NAME        = libasm.a
NASM        = nasm
TEST_NAME   = tester
MAIN_SRC    = main.c

# --- DETECTION DE L'OS ET ARCHITECTURE ---
# --- DETECTION DE L'OS ET ARCHITECTURE ---
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S), Darwin) # macOS (Intel ou Apple Silicon)
    NASM_FLAGS = -f macho64
    # On force x86_64 pour que le linker accepte la libasm.a (macho64)
    CC_FLAGS = -Wall -Wextra -Werror -arch x86_64 
else # Linux (Ecole)
    NASM_FLAGS = -f elf64
    CC_FLAGS = -Wall -Wextra -Werror
endif

# --- SOURCES ---
SRCS        = srcs/ft_strlen.s srcs/ft_strcpy.s srcs/ft_strcmp.s \
              srcs/ft_write.s srcs/ft_strdup.s srcs/ft_read.s
SRCS_BONUS  = srcs_bonus/ft_atoi_base.s srcs_bonus/ft_list_size.s \
              srcs_bonus/ft_list_sort.s srcs_bonus/ft_list_remove_if.s \
              srcs_bonus/ft_list_push_front.s

OBJ_DIR     = obj
OBJ_BONUS_DIR = obj_bonus

OBJS        = $(addprefix $(OBJ_DIR)/, $(notdir $(SRCS:.s=.o)))
OBJS_BONUS  = $(addprefix $(OBJ_BONUS_DIR)/, $(notdir $(SRCS_BONUS:.s=.o)))

# --- VPATH ---
vpath %.s srcs srcs_bonus

# --- REGLES ---
all: $(NAME)

$(NAME): $(OBJS)
	ar rc $(NAME) $(OBJS)
	ranlib $(NAME)

bonus: $(OBJS) $(OBJS_BONUS)
	ar rc $(NAME) $(OBJS) $(OBJS_BONUS)
	ranlib $(NAME)

$(OBJ_DIR)/%.o: %.s
	@mkdir -p $(OBJ_DIR)
	$(NASM) $(NASM_FLAGS) $< -o $@

$(OBJ_BONUS_DIR)/%.o: %.s
	@mkdir -p $(OBJ_BONUS_DIR)
	$(NASM) $(NASM_FLAGS) $< -o $@

test: all
	cc $(CC_FLAGS) $(MAIN_SRC) $(NAME) -o $(TEST_NAME)
	@echo "Compilation de $(TEST_NAME) terminee."

clean:
	rm -rf $(OBJ_DIR) $(OBJ_BONUS_DIR)

fclean: clean
	rm -f $(NAME) $(TEST_NAME)

re: fclean all

.PHONY: all clean fclean re test bonus