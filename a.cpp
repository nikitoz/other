#include <iostream>
#include <iomanip>
#include <stdio.h>
#include <set>
#include <vector>
#include <map>
#include <cmath>
#include <algorithm>
#include <functional>
#include <numeric>
#include <memory.h>
#include <limits>
#include <string>
#include <sstream>
#include <queue>
#include <stdlib.h>
#include <list>
#include <stack>

#define fori(N) for (int i = 0; i != N; ++i)
#define forj(N) for (int j = 0; j != N; ++j)

using namespace std;
#pragma comment(linker, "/STACK:1600000000")
typedef signed long long bint;
typedef long long        ubint;
typedef vector<int>    vint_t;
typedef vector<bint>   vbint_t;
typedef vector<double> vdint_t;

struct node {
	int d;
	node* left; node* right;
	node(int dd, node*l = NULL, node*r = NULL) : d(dd), left(l), right(r) {}
};

void  bst_insert(node** root, int num) {
	while (*root != NULL)
		if (num == (*root)->d)
			return;
		else
			root = num > (*root)->d ? &(*root)->right : &(*root)->left;
	*root = new node(num);
}

void bst_insert_srtd(node** root,  int* arr, int b, int e) {
	if (e - b < 1)
		return;
	int lbound = (e - b - 1) >> 1;
	*root = new node(arr[b + lbound]);
	bst_insert_srtd(&(*root)->left,  arr, b, b + lbound);
	bst_insert_srtd(&(*root)->right, arr, b + lbound + 1, e);
}

void bst_inorder_r(node* root) {
	if (root == NULL) return;
	bst_inorder_r(root->left);
	printf("%d\n", root->d);
	bst_inorder_r(root->right);
}

void bst_inorder(node* root) {
	if (root == NULL) return;
	std::stack<node*> st;
	do {
		if (root) do { st.push(root); } while (root = root->left);
		root = st.top(); st.pop();
		printf("%d\n", root->d);
		root = root->right;
	} while (!st.empty() || root);
}

void bst_postorder_On(node* root) {
	std::stack<node*> st;
	std::stack<int>   o;
	st.push(root);

	do {
		root = st.top(); st.pop();
		o.push(root->d);
		if (root->left)  st.push(root->left);
		if (root->right) st.push(root->right);
	} while (!st.empty());

	do { printf("%d\n", o.top()); o.pop(); } while (!o.empty());
}

void bst_postorder(node* root) {
	std::stack<node*> st;
	node* prev = 0;
	do {
		if (root && root != prev) do { st.push(root); } while (root = root->left);
		root = st.top();
		if (root && root->right && root->right != prev) root = root->right;
		else
		{
			printf("%d\n", root->d);
			prev = root;
			st.pop();
		}
	} while (!st.empty());
}

void bst_preorder_r(node* root) {
	if (root == NULL) return;
	printf("%d\n", root->d);
	bst_preorder_r(root->left);
	bst_preorder_r(root->right);
}

void bst_preorder(node* root) {
	std::stack<node*> st;
	st.push(root);
	do {
		root = st.top(); st.pop();
		printf("%d\n", root->d);
		if (root->right) st.push(root->right);
		if (root->left)  st.push(root->left);
	} while (!st.empty());
}

void bst_postorder_r(node* root) {
	if (root == NULL) return;
	bst_postorder_r(root->left);
	bst_postorder_r(root->right);
	printf("%d\n", root->d);
}

bool bst_is_bst(node* r) {
	return !r || ((!r->left || r->d > r->left->d) && (!r->right || r->d < r->right->d) && bst_is_bst(r->left) && bst_is_bst(r->right));
}

int bst_count(node* r) {
	if (!r) return 0;
	int ret = 0;
	std::stack<node*> st;
	st.push(r);
	do {
		r = st.top(); st.pop();
		while (r) { ++ret; if (r->right) st.push(r->right); r = r->left; }
	} while (!st.empty());
	return ret;
}

node* bst_kth(node* r, int k) {
	if (!r || k < 1) return 0;
	int lftcnt;
	do {
		lftcnt = bst_count(r->left);
		if (lftcnt + 1 > k)
			r = r->left;
		if (lftcnt + 1 < k) {
			r = r->right;
			k -= lftcnt + 1;
			lftcnt = -2;
		}
	} while (lftcnt + 1 != k);
	return r;
}

node* find(node* r, int key) {
	while (r) {
		if (r->d == key)     return r;
		if (r->d > key)      r = r->right;
		else if (r->d < key) r = r->left;
	}
	return r;
}

node** bst_floor(node** root) {
	if (*root == NULL) return 0;
	if ((*root)->left == NULL && (*root)->right == NULL) return root;
	while ((*root)->left) { *root = (*root)->left; }
	return root;
}

void bst_hibbard(node** root, int key) {
	node* prev = 0;
	node* r = *root;
	while (r) {
		if (r->d == key)     return r;
		prev = r;
		if (r->d > key)      r = r->right;
		else if (r->d < key) r = r->left;
	}
	if (r->left == 0 && r->left == 0) {
		if (prev && prev->left == r) {
			delete r;
			prev->left = 0;
		} else if (prev && prev->right) {
			delete r;
			prev->right = 0;
		} else
			delete r;
	} else if (r->left == 0) {
		if (prev && prev->left == r) {
			prev->left = r->right;
			delete r;
		} else if (prev && prev->right) {
			prev->right = r->right;
			delete r;
		} else {
			root = &r->right;
			delete r;
		}
	} else if (r->right == 0) {
		if (prev && prev->left == r) {
			prev->left = r->left;
			delete r;
		} else if (prev && prev->right) {
			prev->right = r->left;
			delete r;
		} else {
			root = &r->left;
			delete r;
		}
	} else {
		node** sub = bst_floor(&(r->right));
		if (prev && prev->left == r) {
			prev->left = *sub;
			sub->left  = r->left;
			sub->right = r->right;
			
			delete r;
		} else if (prev && prev->right) {
			prev->right = r->left;
			delete r;
		}
	}
}

int main() {
	node* r = NULL;
	int sorted[] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22};

	bst_insert_srtd(&r, sorted, 0, 22);
	bst_insert(&r, 1);
	bst_insert(&r, 2);
	bst_insert(&r, 3);
// 	bst_inorder_r(r);   printf("\n");
// 	bst_inorder(r);     printf("\n");
	bst_preorder_r(r);  printf("\n");
	bst_preorder(r);    printf("\n");
// 	bst_postorder_r(r); printf("\n");
// 	bst_postorder(r);
// 	if (bst_is_bst(r))
// 		printf("true");
// 	int cnt = bst_count(r);
// 	printf("%d\n", cnt);
// 	for (int i = 1; i != sizeof(sorted)/sizeof(int)  + 1; ++i)
// 		if (bst_kth(r, i)->d == i)
// 			printf("true");
// 		else
// 			printf("!!!!!!!!!!!!!!!!!!!!!!!!");
	//func(r, 9);
}