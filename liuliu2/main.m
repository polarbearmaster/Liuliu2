//
//  main.m
//  liuliu2
//
//  Created by kenny on 16/5/10.
//  Copyright © 2016年 honeywell. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>

#define COUNT 3
#define OPCOUNT 8
#define MAXBOARD 987654321
int Board[MAXBOARD] = {0};

//typedef int (**Mystype);


typedef struct
{
    int r;//region
    int c;//clockwise
}Step;

Step step1 = {1,0};
Step step2 = {1,1};
Step step3 = {2,0};
Step step4 = {2,1};
Step step5 = {3,0};
Step step6 = {3,1};
Step step7 = {4,0};
Step step8 = {4,1};
Step Steps[8];

#pragma mark: STACK
typedef struct {
    int di;//距离 dis
    Step step;//一步
    int **pt;//走完这一步后的3*3表格数据
}ElementType;

typedef struct node {
    ElementType data;
    struct node *next;
}StackNode, *LinkStack;

void InitStack(LinkStack top) {
    top->next = NULL;
}

int IsEmpty(LinkStack top) {
    if(top->next == NULL) return TRUE;
    return FALSE;
}

int Push(LinkStack top, ElementType element) {
    StackNode *temp;
    temp = (StackNode *)malloc(sizeof(StackNode));
    if(temp == NULL) return FALSE;
    temp->data = element;
    temp->next = top->next;
    top->next = temp;
    return TRUE;
}

int Pop(LinkStack top, ElementType *element) {
    if(IsEmpty(top)) return FALSE;
    StackNode *temp = top->next;
    *element = temp->data;
    top->next = temp->next;
    free(temp);
    return TRUE;
}

void GetTop(LinkStack top, ElementType *element) {
    *element = top->next->data;
}

BOOL StackLoopEnd(LinkStack S) {
    if (IsEmpty(S)) {
        return NO;
    }
    
    ElementType e;
    GetTop(S, &e);
    
    if (e.di == 0) {
        return YES;
    } else {
        return NO;
    }
}

void printStack(LinkStack S) {
    if (S->next == NULL) {
        printf("list is empty.\n");
    } else {
        LinkStack p = S->next;
        while (p != NULL) {
            ElementType e = p->data;
            
            
            //printf("di %d\n", e.di);
            
            if (e.step.r == 0) {
                
            }
            else if (e.step.c == 1) {
                printf("r%d\n", e.step.r);
            } else {
                printf("R%d\n", e.step.r);
            }
            
            //printf("step c:%d r:%d\n", e.step.c, e.step.r);
            /*
            for(int i=0; i<3; i++) {
                for(int j=0; j<3; j++) {
                    printf("%d",*(*(e.pt+i)+j));
                }
                printf("\n");
            }
            printf("\n");
             */
            
            p = p->next;
        }
        printf("\n");
    }
}

///////////////////////////////////////////

void printArray(int **p) {
    for(int i=0; i<3; i++) {
        for(int j=0; j<3; j++) {
            printf("%d",*(*(p+i)+j));
        }
        printf("\n");
    }
    printf("\n");
}

void printOp(Step step) {
    if (step.c == 1) {
        printf("r%d\n", step.r);
    } else {
        printf("R%d\n", step.r);
    }
}

int **op(int **m, Step step) {
    
    int n = step.r;
    int clockwise = step.c;
    //int n, BOOL clockwise
    
    int i,j;
    
    switch (n) {
        case 1: {
            i = 0;
            j = 0;
        }
            break;
        case 2: {
            i = 0;
            j = 1;
        }
            break;
        case 3: {
            i = 1;
            j = 0;
        }
            break;
        case 4: {
            i = 1;
            j = 1;
        }
            break;
        default:
            return m;
            break;
    }
    int a,b,c,d;
    
    a = m[i][j];
    b = m[i][j+1];
    c = m[i+1][j];
    d = m[i+1][j+1];
    
    if (clockwise) {
        m[i][j] = c;
        m[i][j+1] = a;
        m[i+1][j] = d;
        m[i+1][j+1] = b;
    } else {
        m[i][j] = b;
        m[i][j+1] = d;
        m[i+1][j] = a;
        m[i+1][j+1] = c;
    }
    
    //printArray(m);
    return m;
}

int calculMin(int a[], int len) {
    int m = a[0];
    for (int i=1;i<len;i++)
    {
        m = MIN(m,a[i]);
    }
    return m;
}

int myFunction(int a, int b, int c, int d, int e, int f, int g, int h, int i) {
    int base = 10;
    return pow(base, 0)*a + pow(base, 1)*b + pow(base, 2)*c + pow(base, 3)*d + pow(base, 4)*e + pow(base, 5)*f + pow(base, 6)*g + pow(base, 7)*h + pow(base, 8)*i;
}

BOOL myEqual(int **pi, int **pf) {
    BOOL val = true;
    for(int i=0; i<3; i++) {
        for(int j=0; j<3; j++) {
            if (*(*(pi+i)+j) != *(*(pf+i)+j)) {
                val = false;
                break;
            }
        }
    }
    return val;
}

int distance(int **pi, int **pf) {
    int res = 0;
    for(int i=0; i<3; i++) {
        for(int j=0; j<3; j++) {
            for(int k=0; k<3; k++) {
                for(int l=0; l<3; l++) {
                    if (*(*(pi+i)+j) == *(*(pf+k)+l)) {
                        res = res + abs(i-k) + abs(l-j);
                    }
                }
            }
        }
    }
    return res;
}

Step bestOneOp(int **pi, int **pf) {
    Step Steps[8];
    Steps[0] = step1;
    Steps[1] = step2;
    Steps[2] = step3;
    Steps[3] = step4;
    Steps[4] = step5;
    Steps[5] = step6;
    Steps[6] = step7;
    Steps[7] = step8;
    
    int arr[8] = {1000};
    
    for (int i = 0; i < 8; i++) {
        
        int **p = (int **)malloc(3 * sizeof(int *));
        for (int j = 0; j < 3; j++) {
            p[j] = (int *)malloc(3 * sizeof(int));
            for (int k = 0; k < 3; k++) {
                p[j][k] = pi[j][k];
            }
        }
        
        int d = distance(op(p, Steps[i]), pf);
        int myfunc = myFunction(*(*(p+0)+0), *(*(p+0)+1), *(*(p+0)+2), *(*(p+1)+0), *(*(p+1)+1), *(*(p+1)+2), *(*(p+2)+0), *(*(p+2)+1), *(*(p+2)+2));
        if (Board[myfunc] == 0) {
           arr[i] = d;
        } else {
            arr[i] = 1000;
        }
        free(p);
    }
    
    int min = calculMin(arr, 8);
    Step step;
    int j;
    
    for (int i = 0; i < 8; i++) {
        if (arr[i] == min) {
            step = Steps[i];
            j = i;
            break;
        }
    }
    
//    printOp(step);
//    printf("dis: %d\n", min);
    
//    op(pi, step);
    return step;
}

int **returnPointer(int **p) {
    
    int **c;
    c = (int **)malloc(3*sizeof(int *));
    
    for (int i = 0; i<3; i++) {
        c[i] = (int *)malloc(3 * sizeof(int));
        for (int j = 0; j<3; j++) {
            c[i][j] = p[i][j];
        }
    }
    return c;
}

void shortest(int **pi, int **pf) {
    LinkStack S;
    S = (LinkStack)malloc(sizeof(StackNode));
    InitStack(S);
    
    ElementType e;
    Step identity;
    identity.r = 0;
    identity.c = 0;
    
    e.di = distance(pi, pf);
    e.step = identity;
    e.pt = returnPointer(pi);
    
    Push(S, e);
    
    do {
        Step step = bestOneOp(pi, pf);// 最优选择的一步
        //printOp(step);
        
        int **cpi;
        cpi = returnPointer(pi);
        
        // 执行这一步
        int di = distance(op(cpi, step), pf);
        //printf("di: %d\n", di);
        
        ElementType t;
        GetTop(S, &t);
        
        if (di < t.di) {
            op(pi, step);
            ElementType f;
            f.di = di;
            f.step = step;
            f.pt = returnPointer(pi);
            Push(S, f);
            
            //printStack(S);
            
        } else {
            //printStack(S);
            ElementType d;
            Pop(S, &d);
            
            int **p = d.pt;
            int myfunc = myFunction(*(*(p+0)+0), *(*(p+0)+1), *(*(p+0)+2), *(*(p+1)+0), *(*(p+1)+1), *(*(p+1)+2), *(*(p+2)+0), *(*(p+2)+1), *(*(p+2)+2));
            Board[myfunc] = 1;
            
            Step s = d.step;
            Step back;
            back.r = s.r;
            back.c = !s.c;
            
            op(pi, back);
            //printArray(p);
            
            //printStack(S);
            
            
        }
        
    } while (!StackLoopEnd(S));//!StackLoopEnd(S)
    
    // 打印 Stack    
    printStack(S);
    
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        int m[3][3];
        for (int i = 0; i<3; i++) {
            for (int j = 0; j<3; j++) {
                m[i][j] = i*3 + j+1;
            }
        }
        
//        int (*pi)[3] = m;
        int **pi = (int **)malloc(3*sizeof(int *));
        for (int i = 0; i < 3; i++) {
            pi[i] = (int *)malloc(3 * sizeof(int));
            for (int j = 0; j < 3; j++) {
                pi[i][j] = m[i][j];
            }
        }

        
        
        int e[3][3];
        /*
        e[0][0] = 4;
        e[0][1] = 1;
        e[0][2] = 3;
        e[1][0] = 5;
        e[1][1] = 2;
        e[1][2] = 6;
        e[2][0] = 7;
        e[2][1] = 8;
        e[2][2] = 9;
         */
        /*
        e[0][0] = 4;
        e[0][1] = 6;
        e[0][2] = 1;
        e[1][0] = 9;
        e[1][1] = 2;
        e[1][2] = 3;
        e[2][0] = 5;
        e[2][1] = 7;
        e[2][2] = 8;
        */
        
        e[0][0] = 9;
        e[0][1] = 4;
        e[0][2] = 7;
        e[1][0] = 8;
        e[1][1] = 5;
        e[1][2] = 2;
        e[2][0] = 3;
        e[2][1] = 6;
        e[2][2] = 1;
        
        
        int **pf = (int **)malloc(3*sizeof(int *));
        for (int i = 0; i < 3; i++) {
            pf[i] = (int *)malloc(3 * sizeof(int));
            for (int j = 0; j < 3; j++) {
                pf[i][j] = e[i][j];
            }
        }
        
        printArray(pi);
        printArray(pf);
        
//        int dis = distance(pi, pf);
//        printf("dis: %d\n", dis);
//        int alpha = myFunction(9,8,7,6,5,4,3,2,1);
//        int belta = myFunction(4,1,3,5,2,6,7,8,9);
//        int gamma = myFunction(1,2,3,4,5,6,7,8,9);
//        printf("alpha: %d\n", alpha);
//        printf("belta: %d\n", belta);
//        printf("gamma: %d\n", gamma);

        shortest(pi, pf);
        
        /*
        int dis;
        
        //1
        op(pi, step2);
        printArray(pi);
        dis = distance(pi, pf);
        printf("dis: %d\n", dis);
        
        //2
        op(pi, step4);
        printArray(pi);
        dis = distance(pi, pf);
        printf("dis: %d\n", dis);
        
        //3
        op(pi, step8);
        printArray(pi);
        dis = distance(pi, pf);
        printf("dis: %d\n", dis);
        
        //4
        op(pi, step6);
        printArray(pi);
        dis = distance(pi, pf);
        printf("dis: %d\n", dis);
        
        //5
        op(pi, step8);
        printArray(pi);
        dis = distance(pi, pf);
        printf("dis: %d\n", dis);
        
        //6
        op(pi, step4);
        printArray(pi);
        dis = distance(pi, pf);
        printf("dis: %d\n", dis);
        
        //7
        op(pi, step2);
        printArray(pi);
        dis = distance(pi, pf);
        printf("dis: %d\n", dis);
        
        //8
        op(pi, step6);
        printArray(pi);
        dis = distance(pi, pf);
        printf("dis: %d\n", dis);
        
        //9
        op(pi, step8);
        printArray(pi);
        dis = distance(pi, pf);
        printf("dis: %d\n", dis);
        
        //10
        op(pi, step2);
        printArray(pi);
        dis = distance(pi, pf);
        printf("dis: %d\n", dis);
        
        //11
        op(pi, step4);
        printArray(pi);
        dis = distance(pi, pf);
        printf("dis: %d\n", dis);
        
        
        printf("happy ending");
        */

    }
    return 0;
}
