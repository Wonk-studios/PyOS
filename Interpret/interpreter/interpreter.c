#include <Python.h>
#include <stdio.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Error IN31: Usage: %s <script.py>\n", argv[0]);
        return 1;
    }

    if (!Py_IsInitialized()) {
        fprintf(stderr, "Error IN32:Interpreter Initialization Error.\n");
        return 1;
    }

    Py_Initialize();

    FILE* fp = fopen(argv[1], "r");
    if (fp != NULL) {
        int result = PyRun_SimpleFile(fp, argv[1]);
        fclose(fp);
        if (result != 0) {
            fprintf(stderr, "Error IN03: Error executing Python script: %s\n", argv[1]);
            Py_Finalize();
            return 1;
        }
    } else {
        fprintf(stderr, "Error IN34: Script run failed.: %s\n", argv[1]);
        Py_Finalize();
        return 1;
    }

    Py_Finalize();
    return 0;
}
