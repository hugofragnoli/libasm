NAME        = libasm.a

NASM        = nasm
NASM_FLAGS  = -f macho64

SRCS        = srcs/ft_strlen.s srcs/ft_strcpy.s srcs/ft_strcmp.s srcs/ft_write.s srcs/ft_strdup.s
OBJ_DIR     = obj

# Cette ligne transforme "srcs/ft_strlen.s" en "ft_strlen.o" puis ajoute "obj/" devant
OBJS        = $(addprefix $(OBJ_DIR)/, $(notdir $(SRCS:.s=.o)))

all: $(NAME)

# Règle pour dire : "Cherche les fichiers .s dans le dossier srcs/"
vpath %.s srcs

$(OBJ_DIR)/%.o: %.s
	@mkdir -p $(OBJ_DIR)
	$(NASM) $(NASM_FLAGS) $< -o $@

$(NAME): $(OBJS)
	ar rc $(NAME) $(OBJS)
	ranlib $(NAME)

clean:
	rm -rf $(OBJ_DIR)

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re