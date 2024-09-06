class HelloWorld:
    def __init__(self):
        self.message = "Hello world!"

    def get_message(self):
        return self.message

class Printer:
    def __init__(self, message):
        self.message = message

    def print_message(self):
        for char in self.message:
            self._print_char(char)

    def _print_char(self, char):
        print(char, end='')

def main():
    hello_world = HelloWorld()
    message = hello_world.get_message()
    printer = Printer(message)
    printer.print_message()
    print()  # To ensure the next prompt is on a new line

if __name__ == "__main__":
    main()