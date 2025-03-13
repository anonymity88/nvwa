def decorator(func):
    def wrapper():
        print("调用前")
        func()  # 调用原函数
        print("调用后")
    return wrapper

@decorator
def greet():
    print("test")
    print("Hello!")
    print("love you!")

greet()
