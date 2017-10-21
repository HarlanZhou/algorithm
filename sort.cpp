#include<Windows.h>
#include<algorithm>
#include<time.h>
#include<cstdlib>
#include<vector>
#include<iostream>
using namespace std;

//随机数生成函数
void fill_random_init(vector<int>&v,int cnt)
{
	v.clear();
	for (int length=0; length < cnt; length++)
		v.push_back(rand());
}

//交换函数
void swap(int a, int b)
{
	a ^= b;
	b ^= a;
	a ^= b;
}
//快速排序向量版本
void quicksort(vector<int> &list, int left, int right)
{
	if (left < right)
	{
		int l = left, r = right, x = list[left];
		while (l < r)
		{
			while (l < r&&list[r] >= x)//从右往左找第一个小于x的数字
				r--;
			//找到了！
			if (l < r)
				list[l++] = list[r];
			while (l < r&&list[l] < x)//从左向右找第一个大于等于x的数字
				l++;
			if (l < r)
				list[r--] = list[l];
		}
		list[l] = x;//将x 放到他该在的位置
		quicksort(list, left, l - 1);
		quicksort(list, l + 1, right);
	}
}
void quicksort(int list[], int left, int right)
{
	if (left < right)
	{
		int l = left, r = right, x = list[left];
		while (l < r)
		{
			while (l < r&&list[r] >= x)//从右往左找第一个小于x的数字
				r--;
			//找到了！
			if (l < r)
				list[l++] = list[r];
			while (l < r&&list[l] < x)//从左向右找第一个大于等于x的数字
				l++;
			if (l < r)
				list[r--] = list[l];
		}
		list[l] = x;//将x 放到他该在的位置
		quicksort(list, left, l - 1);
		quicksort(list, l + 1, right);
	}
}
//冒泡排序
void bubblesort(vector<int> &list)
{
	for (int i = 0; i < list.size()-1; i++)
	{
		for (int j = 0; j < list.size() - i - 1; j++)
		{
			if (list[j] > list[j + 1])swap(list[j], list[j + 1]);
		}
	}
}
//选择排序
void choosesort(vector<int> &list)
{
	int min,minf;
	for (int i = 0; i < list.size(); i++)
	{
		min = list[i];
		for (int j = i; j < list.size(); j++)
		{
			if (min > list[j])
			{
				min = list[j];
				minf = j;
			}
		}
		swap(list[i], list[minf]);
	}
}
//归并排序
void mergesort()
{

}




void showInfo(int list[])
{
	for (int i = 0;i<11; i++)
	{
		cout << list[i] <<" ";
	}
}
void showInfo(vector<int> &list)
{
	for (int i = 0; i < list.size() - 1; i++)
	{
		cout << list[i] << " ";
	}
	cout << endl;
}
void test_sort(vector<int>&v)
{
	sort(v.begin(), v.end());
}

int main()
{
	int length;
	//cout << "输入待排序的数组的长度" << endl;
	printf("输入待排序的数组的长度,自动生成数组");
	scanf_s("%d", &length);
	srand((int)time(0));
	vector<int> v, k,h,s;

	fill_random_init(v, length);
	k = v;
	h = v;
	s = v;
	printf("-----------系统排序--------------- \n");
	long s1 = GetTickCount();
	test_sort(s);
	long e1 = GetTickCount();
	printf("系统排序总共花费时间%ld \n", e1-s1);

	//printf("排序前");
	//showInfo(v);
	printf("-----------快速排序--------------- \n");
	long start = GetTickCount();
	quicksort(v, 0, length-1);
	long end = GetTickCount();
	long quicktime=end-start;
	printf("排序后");
	//showInfo(v);
	printf("快速排序总共花费时间%ld \n", quicktime);
	printf("-----------冒泡排序--------------- \n");
	start = GetTickCount();
	bubblesort(k);
	end = GetTickCount();
	long bubbletime = end - start;
	printf("冒泡排序后");
	//showInfo(k);
	printf("冒泡排序总过花费时间%ld \n", bubbletime);

	printf("-----------选择排序--------------- \n");
	start = GetTickCount();
	choosesort(h);
	end = GetTickCount();
	long choosetime = end - start;
	printf("选择排序后");
	//showInfo(k);
	printf("选择排序总过花费时间%ld \n", choosetime);
	return 0;
}