- transform.m  transform Raw Data into format data prepare processing for EEG analysis
- learnCSP.m implement CSP to extracted features
- run.m  Main function


# 特征提取的算法

## CSP共空间模式

共空间模式(CSP)是一种对二分类任务下的空间滤波特征提取算法，能够从多通道的脑机接口数据里面提取出每一类的空间分布成分。**共空间模式算法的基本原理是利用矩阵的对角化**，找到一组最优的空间滤波器进行投影，使得两类信号的**方差值差异最大化**，从而得到具有**较高区分度的特征向量**。

  假设$X_1$和$X_2$分别为二分类想象运动任务下的多通道诱发相应时空信号矩阵，他们的维数均为$N*T$,*N*表示脑电的通道数，$T$为每个通道所采集的样本数。为了计算协方差矩阵，现在假设$N<T$。在两种脑电想象任务情况下，一般采用复合源的数学模型来描述$EEG$信号，为了方便计算。一般忽略噪声所产生的影响。$X_1$和$X_2$可以分别写成：

  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$X_1=\left[\begin{matrix} C_1 C_M \end{matrix} \right] \left[\begin{matrix} S_1 \\S_M \end{matrix} \right]$, $X_2=\left[\begin{matrix} C_2 C_M \end{matrix}\right] \left[\begin{matrix} S_2 \\ S_M\end{matrix}\right]$ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (1)



  $(1)$ 式中，分别代表两种类型任务，不妨假设者两个源信号是相互线性独立的；$S_M$代表两种类型任务下所共同拥有的源信号，假设$S_1$是由$m_1$个源所构成的，$S_2$是由$m_2$个源所构成的,则$C_1$和$C_2$便是由$S_1$和$S_2$相关的$m_1$和$m_2$个共同空间模式组成的，由于每个空间模式都是一个$N*1$维的向量，现在用这个向量来表示单个的源信号所引起的信号在$N$个导联上的分布权重。$C_M$表示的是与$S_M$相应的共有的空间模式。$CSP$算法的目标激就是要设计空间滤波器$F_1$和$F_2$得到空间因子$W$

  ###  1.1求两类数据的混合空间协方差矩阵
  $X_1$和$X_2$归一化后的协方差矩阵$R_1$和$R_2$分别为：

  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$R_1=\frac{X_1X_1}{trace(X_1X_1^T)},R_2=\frac{X_2X_2}{trace(X_2X_2^T)}$&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$(2)$

  $(2)$式中：$X_T$表示$X$矩阵的转置，$trace(X)$表示对角线上元素的和，然后求混合空间协方差矩阵R:

  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$R=\bar{R}_1+\bar{R}_2$&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$(3)$

$(3)$ 式中: $\bar{R}_i(i=1,2)$ 分别表示任务12实验的**平均协方差矩阵**

### 1.2应用主成分分析法，求出白化特征值矩阵P

对混合空间协方差矩阵$R$式进行特征值分解

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $R=UλU^T$ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$(4)$

$(4)$式中:$U$是矩阵$λ$的特征向量矩阵，$λ$是对应的特征值构成的对角阵。将特征值及逆行降序排列，白化值矩阵为：
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$P=\sqrt{λ^{-1}}U^T$&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$(5)$

### 1.3构造空间滤波器

对$R_1$和$R_2$进行如下变换：

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$S_1=PR_1P^T,S_2=PR_2P^T$&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$(6)$

然后对$S_1$和$S_2$做主分量分解，得到:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$S_1=B_1λ_1B_1^T,S_2=B_2λ_2B_2^T$

通过上面的式子可以证明矩阵$S_1$的特征向量和矩阵$S_2$的特征向量矩阵是相等的，即：

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$B_1=B_2=V$&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

与此同时，两个特征值的对角阵$λ_1$和$λ_2$之和为单位矩阵，即：

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$λ_1+λ_2=I$

由于两类矩阵的特征值相加总是1，则$S_1$的最大特征值所对应的特征向量使$S_2$有最小的特征值，反之亦然。

把$λ_1$中的特征值按照降序排列，则$λ_2$中对应的特征值按升序排列，根据这点可以推断出$λ_1$和$λ_2$具有下面的形式：


白化EEG到与$λ_1$和$λ_2$中的最大特征值对应的特征向量的变换对于分离两个信号矩阵中的方差是最佳的。投影矩阵$W$是对应的空间滤波器为:
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$W=B^TP$


### 1.4特征提取

将训练集的运动想象矩阵$X_L,X_R$经过构造的相应滤波器$W$滤波可得特征$Z_L,Z_R$为：

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$Z_L=W×X_L$&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$Z_R=W×X_R$&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

根据$CSP$算法在多电极采集脑电信号特征提取的定义，本研究选取$f_L$和$f_R$为想象左和想象右的特征向量，
定义如下：

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;$f_L = \frac{var(Z_L)}{\sum{var(Z_L)}}$

对于测试数据$X_i$来说，其特征向量$f_i$提取方式如下，并与$f_L$和$f_R$进行比较以确定第i次想象为想象左或者想象右。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
$$
\left\{
  \begin{aligned}
  Z_i& = & W×X_i \\
  f_i& = & \frac{var(Z_i)}{\sum{var(Z_i)}}
\end{aligned}
\right.
$$

