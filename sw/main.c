// Chuong trinh C mau chay tren CPU RISC-V don chu ky
//   - arr[] nam trong .data  (gia tri ban dau nap vao DMEM tu dmem.hex)
//   - w[]   nam trong .rodata (hang so, cung nam trong DMEM)
//   - count nam trong .bss   (crt0.S xoa ve 0)
//   - phep nhan a*b -> GCC goi ham __mulsi3 trong libgcc (CPU chua co lenh mul)
// Ket qua: sap xep arr = {1,2,3,4,5,7,8,9}
//          1*1 + 2*2 + 3*3 + 4*4 + 5*5 + 7*6 + 8*7 + 9*8 = 225
// EXPECT: 225

int arr[8] = {5, 3, 8, 1, 9, 2, 7, 4};
const int w[8] = {1, 2, 3, 4, 5, 6, 7, 8};
int count;                              // so lan doi cho

static void bubble_sort(int *a, int n)
{
    for (int i = 0; i < n - 1; i++)
        for (int j = 0; j < n - 1 - i; j++)
            if (a[j] > a[j + 1]) {
                int t = a[j];
                a[j] = a[j + 1];
                a[j + 1] = t;
                count++;
            }
}

int main(void)
{
    bubble_sort(arr, 8);

    int s = 0;
    for (int i = 0; i < 8; i++)
        s += arr[i] * w[i];
    return s;
}
