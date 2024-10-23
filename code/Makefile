# 定义编译器和编译选项
CC = gcc
CFLAGS = -Wall -g

# 定义目标可执行文件名称
TARGET = program

# 源文件列表
SRCS = add.c mul.c hello.c  # 确保所有源文件都在当前目录中

# 计算对象文件列表
OBJS = $(SRCS:.c=.o)

# 默认目标
all: $(TARGET)

# 链接对象文件生成可执行文件
$(TARGET): $(OBJS)
	$(CC) -o $@ $^

# 编译源文件为对象文件
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# 清理目标
clean:
	rm -f $(OBJS) $(TARGET)

# 声明伪目标
.PHONY: all clean

