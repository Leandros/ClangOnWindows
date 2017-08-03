#include <stdio.h>
#include <windows.h>
#include <iostream>

int
main(void)
{
    std::cout << "hello, world\n";
    printf("hello, world\n");
    MessageBoxW(NULL, L"Test 123", L"Row2", MB_ICONWARNING | MB_CANCELTRYCONTINUE);
    return 0;
}

