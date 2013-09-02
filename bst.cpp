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

template <typename T>
struct node {
	node* left_;
	node* right_;
	T     data_;
	node(const T& data, node* left = 0, node* right = 0) 
		: data_(data), left_(left), right_(right) { }
};

template <typename T, typename TPred>
struct bst {
	typedef node <T> node_t;
	node_t* root;
	TPred   pred;// left - true, right - false

	bst() 
		: root(0) { }

	~bst() {
		cleanup();
	}

	void insert(const T& data) {
		if (root == 0) return (void)(root = new node_t(data));
		node_t* t = root;
		while (t && t->data_ != data) {
			bool condition = pred (data, t->data_);
			if (condition && t->left_ == 0)
				return (void)(t->left_ = new node_t(data));
			else if (!condition && t->right_ == 0)
				return (void)(t->right_ = new node_t(data));
			else
				t = condition ? t->left_ : t->right_;
		}
	}

	node_t* search(const T& data) {
		node_t* t = root;
		while (t && t->data_ != data) {
			t = pred(data, t->data_) ? t->left_ : t->right_;
		}
		return t;
	}

	void remove(const T& data) {
		node_t* p = root;
		node_t* t = root;
		while (t && t->data_ != data) {
			p = t;
			t = pred(data, t->data_) ? t->left_ : t->right_;
		}

		if (0 == t) return;
		if (0 == t->right_) {
			if (t == p->left_)
				p->left_ = t->left_;
			else if (t == p->right_)
				p->right_ = t->left_;
			else if (t == p)
				root = t->left_;
		} else if (0 == p->left_) {
			if (t == p->left_)
				p->left_ = t->right_;
			else if (t == p->right_)
				p->right_ = t->right_;
			else if (t == p)
				root = t->right_;
		} else {
			node_t* substitution = t->right_;
			node_t* substitution_parent = t;
			while (substitution->left_) {
				substitution_parent = substitution;
				substitution = substitution->left_;
			}

			if (substitution_parent != t) {
				if (substitution_parent->left_ == substitution)
					substitution_parent->left_ = substitution->right_;
				else
					substitution_parent->right_ = substitution->right_;
			}

			if (t == p->left_)
				p->left_ = substitution;
			else if (t == p->right_)
				p->right_ = substitution;
			else
				root = substitution;
			substitution->left_ =  t->left_;
			if (substitution != t->right_)
				substitution->right_ = t->right_;
		}
		delete t;
	}

	node_t* least(node_t* r) {
		if (0 == r)
			return 0;
		while (r->left_)
			r = r->left_;
		return r;
	}

	void erase(const T& data) {
		root = erase_ir(root, data);
	}

	void from_sorted(const T* a,  int n) {
		cleanup();
		root = from_sorted_i(a, 0, n);
	}

	void print_inorder() {
		print_inorder_ir(root);
		printf("\n");
	}

	void cleanup() {
		cleanup_i(root);
	}

	node_t* dll() {
		return dll_ir(root, false);
	}

private:
	node_t* dll_ir(node_t* r, bool is_left) {
		if (0 == r)
			return 0;
		node_t* left  = dll_ir(r->left_, true);
		node_t* t = new node_t(r->data_, left);
		if (left)
			left->right_ = t;
		node_t* right = dll_ir(r->right_, false);
		t->right_ = right;
		if (right)
			right->left_ = t;

		if (!is_left)
			while (t->left_)  t = t->left_;
		else
			while (t->right_) t = t->right_;

		return t;
	}

	node_t* erase_ir(node_t* r, const T& data) {
		if (0 == r)
			return 0;
		if (r->data_ == data) {
			node_t* ret = 0;
			if (0 == r->left_)
				ret = r->right_;
			else if (0 == r->right_)
				ret = r->left_;
			else {
				node_t* substitution = least(r->right_);
				ret = new node_t(substitution->data_);
				r->right_ = erase_ir(r->right_, substitution->data_);
				ret->left_ = r->left_;
				ret->right_= r->right_;
			}
			delete r;
			return ret;
		} else if (pred(data, r->data_)) {
			r->left_  = erase_ir(r->left_, data);
		} else {
			r->right_ = erase_ir(r->right_, data);
		}
		return r;
	}

	node_t* from_sorted_i(const T* a, int s, int e) {
		if (a == 0 || e <= s) return 0;
		int median = s + ((e-s)/2);
		return new node_t(a[median], from_sorted_i(a, s, median), from_sorted_i(a, median+1, e));
	}

	void print_inorder_ir( node_t* r ) {
		if (0 == r) return;
		print_inorder_ir(r->left_);
		printf("%d ", r->data_);
		print_inorder_ir(r->right_);
	}

	void cleanup_i(node_t* r) {
		if (0 == r) return;
		cleanup_i(r->left_);
		cleanup_i(r->right_);
		delete r;
	}
};


int main() {
	typedef bst<int, std::less<int> > bst_t;
	bst_t btree;
	int sorted[] = {1,2,3,4,5,6,7};
	btree.from_sorted(sorted, sizeof(sorted)/sizeof(int));
	btree.print_inorder();
	/*
	printf("will remove 4 : ");
	btree.remove(4);
	btree.print_inorder();
	printf("will remove 1 : ");
	btree.remove(1);
	btree.print_inorder();
	printf("will remove 7 : ");
	btree.remove(7);
	btree.print_inorder();
	printf("will remove 5 : ");
	btree.remove(5);
	btree.print_inorder();
	printf("will remove 2 : ");
	btree.remove(2);
	btree.print_inorder();
	printf("will remove 3 : ");
	btree.remove(3);
	btree.print_inorder();
	printf("will remove 6 : ");
	btree.remove(6);
	btree.print_inorder();
	*/

	bst_t::node_t* h = btree.dll();

	while (h) {
		printf("%d ", h->data_);
		h = h->right_;
	}
	printf("\n");

// 	printf("will remove 4 : ");
// 	btree.erase(4);
// 	btree.print_inorder();
// 	printf("will remove 1 : ");
// 	btree.erase(1);
// 	btree.print_inorder();
// 	printf("will remove 7 : ");
// 	btree.erase(7);
// 	btree.print_inorder();
// 	printf("will remove 5 : ");
// 	btree.erase(5);
// 	btree.print_inorder();
// 	printf("will remove 2 : ");
// 	btree.erase(2);
// 	btree.print_inorder();
// 	printf("will remove 3 : ");
// 	btree.erase(3);
// 	btree.print_inorder();
// 	printf("will remove 6 : ");
// 	btree.erase(6);
// 	btree.print_inorder();
	return 0;
}
