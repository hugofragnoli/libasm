NAME        = libasm.a
NASM        = nasm
NASM_FLAGS  = -f macho64

TEST_NAME   = tester
MAIN_SRC    = main.c

SRCS        = srcs/ft_strlen.s srcs/ft_strcpy.s srcs/ft_strcmp.s \
              srcs/ft_write.s srcs/ft_strdup.s srcs/ft_read.s
OBJ_DIR     = obj
OBJS        = $(addprefix $(OBJ_DIR)/, $(notdir $(SRCS:.s=.o)))

SRCS_BONUS  = srcs_bonus/ft_atoi_base.s srcs_bonus/ft_list_size.s \
              srcs_bonus/ft_list_push_front.s srcs_bonus/ft_list_sort.s \
              srcs_bonus/ft_list_remove_if.s
OBJ_BONUS_DIR = obj_bonus
OBJS_BONUS  = $(addprefix $(OBJ_BONUS_DIR)/, $(notdir $(SRCS_BONUS:.s=.o)))

all: $(NAME)

bonus: $(OBJS) $(OBJS_BONUS)
	ar rc $(NAME) $(OBJS) $(OBJS_BONUS)
	ranlib $(NAME)

$(NAME): $(OBJS)
	ar rc $(NAME) $(OBJS)
	ranlib $(NAME)

# On utilise vpath pour que Make trouve les fichiers dans les deux dossiers
vpath %.s srcs srcs_bonus

$(OBJ_DIR)/%.o: %.s
	@mkdir -p $(OBJ_DIR)
	$(NASM) $(NASM_FLAGS) $< -o $@

$(OBJ_BONUS_DIR)/%.o: %.s
	@mkdir -p $(OBJ_BONUS_DIR)
	$(NASM) $(NASM_FLAGS) $< -o $@

test: all
	cc -Wall -Wextra -Werror -arch x86_64 $(MAIN_SRC) $(NAME) -o $(TEST_NAME)
	@echo "Compilation de $(TEST_NAME) terminée."

clean:
	rm -rf $(OBJ_DIR) $(OBJ_BONUS_DIR)

fclean: clean
	rm -f $(NAME) $(TEST_NAME)

re: fclean all

.PHONY: all clean fclean re test bonus