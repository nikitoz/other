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
#include <list>
#include <stack>
#include <iterator>

namespace op {
	template <typename T>
	struct plus_one {
		void operator()(T& t) { t+=3; }
	};

	template <typename T>
	struct greater5 {
		bool operator()(const T& t) { return (t < 5); }
	};

	template <typename TRange, typename Foo>
	struct map {
		Foo foo_;
		map(Foo foo) : foo_(foo) {}
		void operator()(TRange& in) { for_each( in.begin, in.end, foo_ ); }
	};

	template <typename TRange, typename Foo>
	struct remove {
		Foo foo_;
		remove(Foo foo) : foo_(foo) { }
		void operator()(TRange& in) {
			in.end = std::remove_if(in.begin, in.end, foo_);
		}
	};

	template <typename TRange>
	struct nop {
		void operator()(TRange& in) { }
	};
};

using namespace op;

template <typename TIter>
struct range {
	
	typedef TIter type;
	typedef range<type> this_t;

	TIter begin;
	TIter end;
	range(TIter b, TIter e)
		: begin (b), end (e)
	{ }

	range(const this_t& in)
		: begin (in.begin), end (in.end)
	{ }
};

template <typename TColl, typename T, typename TTransform, typename TAtom>
struct atom {
	typedef atom<TColl, T, TTransform, TAtom> this_t;
	typedef range<typename TColl::iterator>   range_t;

	range_t     range_;
	TTransform  foo_;
	TAtom       obj_;

	atom(range_t r, TTransform foo, TAtom obj)
		: range_(r), foo_(foo), obj_(obj)
	{ }

	std::vector<T> toVector() {
		range_t r = eval();
		return std::vector<T>(r.begin, r.end);
	}

	range_t eval() {
		range_t r = obj_.eval();
		foo_(r);
		return r;
	}

	template <typename TFoo>
	atom<TColl, T, map<range_t, TFoo >, this_t > foreach(TFoo foo) {
		return atom< TColl, T, op::map< range_t, TFoo >, this_t >   (range_, op::map<range_t, TFoo >(foo), *this );
	}
	
	template <typename TFoo>
	atom<TColl, T, op::remove<range_t, TFoo >, this_t > remove(TFoo foo) {
		return atom< TColl, T, op::remove< range_t, TFoo >, this_t >(range_, op::remove<range_t, TFoo >(foo), *this );
	}
};

template <typename TColl, typename T>
struct copy_atom {
	typedef copy_atom<TColl, T>             this_t;
	typedef range<typename TColl::iterator> range_t;
	TColl   collection;
	range_t in;

	copy_atom(range_t r) 
		: in(r) 
	{ }

	range_t eval() {
		std::copy(in.begin, in.end, std::inserter(collection, collection.begin()));
		return range_t(collection.begin(), collection.end());
	}
};

template <typename T>
atom<std::vector<T>, T, nop< range< typename std::vector<T>::iterator > >,  copy_atom<std::vector<T>, T> > 
fromVector(std::vector<T>& vec) {
	typedef range< typename std::vector<T>::iterator > range_t;
	typedef copy_atom< typename std::vector<T>, T>     sent_t;
	return atom<std::vector<T>, T, nop<range_t>,  sent_t> ( range_t(vec.begin(), vec.end()), nop<range_t>(), sent_t(range_t(vec.begin(), vec.end())) );
}

int main() {
	std::vector<int> vec;
	vec.push_back(1); vec.push_back(2);  vec.push_back(5);  vec.push_back(4);

	std::vector<int> v = fromVector(vec)
		.foreach(plus_one<int>())
		.remove (greater5<int>())
		.foreach(plus_one<int>())
		.toVector();



	for (int i = 0; i != v.size(); ++i) {
		std::cout << v[i] << " ";
	}
	return 0;
}

