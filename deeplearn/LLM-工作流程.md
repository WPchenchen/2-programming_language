- 精读《Attention Is All You Need》原始论文
- 学习Transformer可视化教程：[jalammar.github.io](https://jalammar.github.io/illustrated-transformer/)

​			自我总结：预训练本质在于【续写】，续写不能很好的回答用户问题，但是拥有很多知识。需要我们引导教会模型【如何对话】（编写各式各样的问题和回答），这就是<u>**这就是 Instruction Tuning 要做的事情，即指令对齐**。</u>

深度学习

因为指令数据有限引导的对话也有限，减少因对话数据有限（数据本身也存在偏见）,模型本身也存在错误和有害的内容，SFT可能会生成带有偏见或不当内容的文本

sft不能够向后看，RLHF可以帮助模型更好地**理解复杂的上下文和长距离依赖关系**。

模型存在的错误和有害没有被修改，所以需要**深度强化学习**的负反馈来解决这问题（知道下一个token的对错）

安全性和泛化性



### 1. 核心架构：Transformer**

LLM基于**Transformer架构**（2017年由Google提出），其核心是通过**自注意力机制**（Self-Attention）捕捉文本中的长距离依赖关系，取代了传统的RNN/CNN。

- **目标**：通过海量文本学习语言统计规律。

- **方法**：

  - **掩码语言建模（MLM）**：随机遮盖部分文本，预测被遮盖内容（如BERT）。文本分类和问答
  - **自回归建模**：逐词预测下一个词（如GPT系列）。生成任务-文本创作
  - **序列建模**

- **数据**：通常使用TB级互联网文本（书籍、网页等）。

- **关键组件**：

  - **多头注意力（Multi-Head Attention）**：并行分析词语在不同语义空间中的关系。MLA/GQA/MQA/MHA

    时间复杂度：O(n^2*d)

    ​						M个头、n维度、d隐藏层数、每个头的维度a，Transformer将d进行拆分为m个a维度向量，这样是的QK的维度为m-n-a。 

    ​						Q m-n-a  * K m-n-a 张量点积  （就是n-a *  n-a 做了m次）

    ​						结果是m-n-n     	主要是split、transpose、reshape，大矩阵变成多个小矩阵相乘

    ​						

  - **位置编码（Positional Encoding）**：注入词序信息（因Transformer本身无时序处理能力）。 旋转位置编码[RoPE](https://zhida.zhihu.com/search?content_id=229525142&content_type=Article&match_order=1&q=RoPE&zhida_source=entity)

  - **前馈神经网络（FFN）**：对注意力结果进行非线性变换。

    ​											升维度：模型在高纬度能够更好的学习和表示特征。非线性激活函数的非线性变换，增强模型的表达能力，使模型能够捕捉更复               杂的模式和关系。

    ​											降维度：输入输出维度一致，信息整合和压缩，精炼数据特征。

    ​										

  - **自注意力机制**：

    > ​       事实上Self Attention是一种思想、机制，而Scaled Dot-Product Attention缩放点积注意力机制是一种计算attention分数的方式。transformer中的Self Attention就是使用Scaled Dot-Product Attention来实现的。

    1. 用于序列数据（文本/时间序列/音频等）的建模，可捕抓不同位置的依赖关系。-（存在位置embedding ）

    2. 可以并行计算，有效加速/更容易再GPU和TPU上进行搞笑训练和推理。
  
      3. 更好地处理长距离依赖（RNN存在梯度消失和梯度爆炸）
  
    - **注意力机制**在Decode block中才有，Endecode中使用的自注意力机制
    
    - 🧠 **Encoder vs Decoder**
    
      
    
      | 项目           | Encoder（编码器）                              | Decoder（解码器）                                            |
      | -------------- | ---------------------------------------------- | ------------------------------------------------------------ |
      | **功能**       | 理解输入内容（做信息提取）                     | 根据上下文生成输出（一个字一个字预测）                       |
      | **典型应用**   | 文本分类、句子编码、BERT                       | 文本生成、机器翻译、GPT、ChatGPT                             |
      | **注意力机制** | 自注意力（Self-Attention，无遮挡）             | 遮挡自注意力（Masked Self-Attention）+ 编码器-解码器注意力（Cross-Attention【KV对齐】） |
      | **输入/输出**  | 输入整段，输出整段隐藏表示（隐层向量）         | 输入之前生成的 token，输出新 token                           |
      | **并行性**     | 可以并行处理整段输入（因为看到的是完整上下文） | 解码阶段必须一个一个按顺序生成（自回归）                     |
      
    - ##### 注意力机制中可以用低秩矩阵？
    
      **注意力矩阵本身就具有低秩特性**，注意力机制的秩也可能远小于原始维度。LoRA的原论文就将低秩矩阵用在了QKV的权重中，经过实验，他们主要在Q和V的权重矩阵添加LoRA。可以从QKV的作用角度加以区分：Q将输入映射到‘查询’空间，用于分配注意力，不同任务关注的角度不同；K将输入映射到‘键’空间，代表对语句的语法和语义进行建模的能力，需要形成稳定的表达，V将输入映射到‘值’空间，不同的任务对内容提取的特征不同。相对于K而言，QV更加具有敏感性。
    
      MQA和GQA，相对于MHA而言，其实也是一种低秩运算，将原本有n对的KV权重矩阵，只保留g对：

输入 - 词嵌入 - 位置编码 - 基于时间步的词嵌入 -  多头注意力机制 - Add&Normalize （残差【**防止网络退化**】和归一【1、加快训练速度2、提高训练的稳定性 Layer Normalization】） -  全连接层 （Freed Forward）

### 多头注意力（Multi-Head Attention) MHA

##### 输入

![image-20250423163914591](images\image-20250423163914591.png)

##### 多头注意力输出的结果   前馈层只需要一个矩阵 （多头分为8个头，每个头都是一个自注意力）----加权求和



![image-20250423163820120](images\image-20250423163820120.png)

![image-20250423170231610](images\image-20250423170231610.png)

**M公式如下：**

![image-20250423171927923](images\image-20250423171927923.png)

![image-20250423165924544](images\image-20250423165924544.png)

#### 什么是Multi-Head Attention? 以及详细流程介绍[学习笔记：transformer知识点总结 - 知乎](https://zhuanlan.zhihu.com/p/648668630)

> ​		它就是计算了多个Scaled Dot-Product Attention（缩放点积注意力机制）的结果然后再concat，再通过[全连接层](https://zhida.zhihu.com/search?content_id=232278603&content_type=Article&match_order=1&q=全连接层&zhida_source=entity)输出。
>
> ​		为什么是多个？因为我们会把输入的数据分为 Q、K、V 三份，Q、K、V 又会被分成多份，分别输入到Scaled Dot-Product Attention，至于这个多份具体是几份，就是和你设的值有关系了。比如你设为8，Q、K、V 就会被分成8份，分别输入到注意力层中，得到8份结果再concat。

![multi-Head Attention](./images\multi-Head Attention.jpg)

##### 什么是Scaled Dot-Product Attention? 

> **缩放点积注意力机制**的基本思想是，对于查询（Query）和一系列键值对（Key-Value Pairs）的集合，通过计算查询与每个键的点积，并利用softmax函数转换这些点积为概率分布，以此来确定每个值的重要性，最终加权求和得到输出。
>
> softmax（QK/Dk）*V

<img src="./images\Scale Dot-Product Attention'.jpg" alt="Scale Dot-Product Attention'" style="zoom: 80%;" />

##### Multi-Head Attention 详细流程

​		1.输入句子为例，首先进行词嵌入（world embbeding）处理成feature向量，再进行Positionnal Embbeding 的得到向量进行concat得到向量I

​		2.向量I分别和权重Wq、Wk、Wv相乘得到Q、K、V，之后不断迭代更新这个权重Wq、Wk、Wv。

<img src="./images\QKV多份.jpg" alt="QKV多份" style="zoom: 33%;" />

​		3.以q1为例子，q和向量k做MatMul点积，在做Scale缩放（除上根号 d （d是 K 的维度））得到a1。

​		4.选择做Mask操作，一般再decode中有存在，进行mask遮挡的时候，我们可以在该位置填上一个负无穷的值，因为这样在后面进行softmax操作的时候，这些位置信息的概率就会无限逼近0<img src="images\多头mask.jpg" alt="多头mask" style="zoom:50%;" />

​		5.得到的向量 a1 再经过Soft-max层得到向量 a1 hat。  

<img src="./images\向量a1进行Soft.jpg" alt="向量a1进行Soft" style="zoom:50%;" />

​		6.得到的向量 a1 hat再与向量 V 作**MatMul**得到最后的输出结果 向量 b1 ，直到算完整个向量b之后，向量b又会变成向量a作为下一轮Encoder的输入。 到这里计算完成**Scaled Dot-Product Attention**。

<img src="./images\scale-Dot-Puduct.jpg" alt="scale-Dot-Puduct" style="zoom:50%;" />

### MHA、MQA、GQA和MLA[【attention1】MHA、MQA、GQA和MLA - 知乎](https://zhuanlan.zhihu.com/p/21151178690)

KV cache缓存 少用一点从MHA-MQA           

 【上下文长度从2k-4k-8k ，导致kv缓存巨大（减少kv cache对显存的占用，保持性能不受影响）】

<img src="./images\image-20250524143214396.png" alt="image-20250524143214396" style="zoom:67%;" />

每个head的Query 共享K和V矩阵，KV cache的内存占用直接降到了 1/n 。

不过这么做的效果还是会有折扣的，即性能上的下降不可避免，也会影响模型的稳定性。

##### 折中使用GQA：

​			1既然每个Q用一个KV太多，一起用一个又不够，不如来个折中，一组用一个：**G**rouped-**Q**uery**A**ttention

<img src="./images\image-20250524143737504.png" alt="image-20250524143737504" style="zoom:67%;" />

​			用一个可配的 g 对Query进行分组， g=1 就是MQA， g=n 就是MHA

##### 降秩MLA

​			DeepSeek V2提出了MLA，**M**ulti-head**L**atent**A**ttention，其本质思想是将原本的权重**降秩**成两个，大家伙先**公用**一个KV权重，就像MHA那样，而**私有**的KV权重，这能藏在哪里呢？如果能够转移到Q和输出O上，是不是就即节省了内存，又不降低性能呢？

![image-20250524150825786](./images\image-c.png)

![image-20250524142814339](./images\image-20250524142814339.png)

### Masked Multi-Head Attention

​		与Encoder的Multi-Head Attention计算原理一样，只是多加了一个mask码。mask 表示掩码，它对某些值进行掩盖，使其在参数更新时不产生效果。Transformer 模型里面涉及两种 mask，分别是 padding mask 和 sequence mask。为什么需要添加这两种mask码呢？

#### padding mask

​			什么是 padding mask 呢？因为每个批次输入序列长度是不一样的也就是说，我们要对输入序列进行对齐。具体来说，**就是给在较短的序列后面填充 0。但是如果输入的序列太长，则是截取左边的内容，把多余的直接舍弃。**因为这些填充的位置，其实是没什么意义的，所以我们的attention机制不应该把注意力放在这些位置上，所以我们需要进行一些处理。
​			具体的做法是，把这些位置的值加上一个非常大的负数(负无穷)，这样的话，经过 softmax，这些位置的概率就会接近0！

#### sequence mask

​			sequence mask 是为了使得 decoder 不能看见未来的信息。对于一个序列，在 time_step 为 t 的时刻，我们的解码输出应该只能依赖于 t 时刻之前的输出，而不能依赖 t 之后的输出。因此我们需要想一个办法，把 t 之后的信息给隐藏起来。这在训练的时候有效，因为训练的时候每次我们是将target数据完整输入进decoder中地，预测时不需要，预测的时候我们只能得到前一时刻预测出的输出。
那么具体怎么做呢？也很简单：产生一个上三角矩阵，上三角的值全为0。把这个矩阵作用在每一个序列上，就可以达到我们的目的。

#### 注意：

1、在Encoder中的Multi-Head Attention也是需要进行mask的，只不过Encoder中只需要padding mask即可，而Decoder中需要padding mask和sequence mask。
2、Encoder中的Multi-Head Attention是基于Self-Attention地，Decoder中的第二个Multi-Head Attention就只是基于Attention，它的输入Quer来自于Masked Multi-Head Attention的输出，Keys和Values来自于Encoder中最后一层的输出。

#### 输出

​				Output如图中所示，首先经过一次线性变换（线性变换层是一个简单的全连接神经网络，它可以把解码组件产生的向量投射到一个比它大得多的，被称为对数几率的向量里），然后Softmax得到输出的概率分布（softmax层会把向量变成概率），然后通过词典，输出概率最大的对应的单词作为我们的预测输出。

transformer的优缺点：
优点：
1、效果好
2、可以并行训练，速度快
3、很好的解决了长距离依赖的问题
缺点：
完全基于self-attention，对于词语位置之间的信息有一定的丢失，虽然加入了positional encoding来解决这个问题，但也还存在着可以优化的地方。

原文链接：https://blog.csdn.net/weixin_42475060/article/details/121101749

### **2. 训练流程**

#### **(1) 预训练（Pretraining Stage）

​		选择较强的基座模型上进行微调-，适合在预训练模型和下游任务差距不大，预训练模型中已经包含微调任务中所需要的（）

##### 	（1.1）Tokenizer Training（分词器负责将原始文本转换为模型可处理的离散单元（Token），其质量直接影响模型性能。）

​				优秀的英文模型在中文语料上进行二次预训练[ymcui/Chinese-LLaMA-Alpaca: 中文LLaMA&Alpaca大语言模型+本地CPU/GPU训练部署 (Chinese LLaMA & Alpaca LLMs)](https://github.com/ymcui/Chinese-LLaMA-Alpaca)

##### 				词表  tokennize的目的就是将一句话进行切词成为token 并从词表上对应tokenid，为给大模型进行训练。1

- ###### 		#WorldPiece     =》BERT就是这样的切词（找不到的内容会被记为[UNK] ->101）	

```python
输入句子 >>> 你好世界
切词结果 >>> ['你', '好', '世', '界']
encode token :['[CLS]','你'， '好', '世', '界','[SEP]']
encode token ids :['101','872', '1962', '686', '4518','102']   #从词表中对应的id  用于模型训练   
```

​			WordPiece 的方式很有效，但当字词**数目过于庞大时**这个方式就有点难以实现了。对于一些多语言模型来讲，要想穷举所有语言中的常用词（**穷举不全会造成 OOV**[词汇表外词]），

既费人力又费词表大小，为此，人们引入另一种方法：BBPE。

- ###### 	#Byte-level BPE（BBPE）

​					BPE 不是按照中文字词为最小单位，而是按照 unicode 编码 作为最小粒度。

​					对于中文来讲，一个汉字是由 3 个 unicode 编码组成的，

​					我们来看看 LLaMA 的 tokenizer 对中文是如何进行 encode 的：			

![image-20250423214359959](images\待编码.png)			自可视化工具 [[tokenizer_viewer](https://link.zhihu.com/?target=https%3A//github.com/HarderThenHarder/transformers_tasks/blob/main/tools/tokenizer_viewer/readme.md)]。

| BBPE 的优势     | 不会出现 OOV 的情况。不管是怎样的汉字，只要可以用 unicode 表示，就都会存在于词表中。 |
| --------------- | ------------------------------------------------------------ |
| **BBPE 的劣势** | **模型训练起来将会更吃力一些。毕竟像「待」这样的汉字特定 unicode 组合其实是不需要模型学习的，但模型却需要通过学习来知道合法的 unicode 序列。** |

- ######    #词表扩充

​			为了**降低模型的训练难度**，人们通常会考虑在原来的词表上进行「词表扩充」，也就是将一些常见的**汉字 token 手动添加到原来的 tokenizer** 中，从而降低模型的训练难度。

##### （1.2）Language Model  PreTraining（输入一堆文字，让模型Next Token Prediction）	大量的网络预料进行无监督的学习

- ​		数据源采样（数据来源的比重，不倾向于大规模而失去对小规模的数据集学习）

- ​		数据预处理 （向量化）[文本截断2048token但是书籍远超过找个token，所以按照seq_len（2048）作为分割，分割后向量为给模型做训练]

- ​		模型结构（在decoder模型中加入一些tricks来缩短训练周期，目前大部分都集中在Attention计算上）（如：MQA 和 Flash Attention [[falcon](https://link.zhihu.com/?target=https%3A//huggingface.co/tiiuae/falcon-40b)] 等）；

  ​        此外，为了让模型能够在不同长度的样本上都具备较好的推理能力（外推性），通常也会在 Position Embedding 上进行些处理，选用 [ALiBi](https://zhida.zhihu.com/search?content_id=229525142&content_type=Article&match_order=1&q=ALiBi&zhida_source=entity)（[[Bloom](https://link.zhihu.com/?target=https%3A//huggingface.co/bigscience/bloom-7b1)]）或 旋转位置编码[RoPE](https://zhida.zhihu.com/search?content_id=229525142&content_type=Article&match_order=1&q=RoPE&zhida_source=entity)（[[GLM-130B](https://link.zhihu.com/?target=https%3A//huggingface.co/spaces/THUDM/GLM-130B)]）等。

  具体内容可以参考下面这篇文章

  - Warmup & Learning Ratio 设置

  在继续预训练中，我们通常会使用 warmup 策略，此时我们按照 2 种不同情况划分：

  1. 当训练资源充足时，应尽可能选择较大的学习率以更好的适配下游任务；
2. 当资源不充足时，更小的学习率和更长的预热步数或许是个更好的选择。

  具体内容可以参考下面这篇文章

  [如何更好地继续预训练（Continue PreTraining） - 知乎](https://zhuanlan.zhihu.com/p/654463331)

- 训练解决显存不足的问题

  ​		增量预训练/参数高效微调 lora/adapter 来训练

  ​		分布式训练优化技术：比如混合精度、zero系列优化、重计算

  ​        Gpu挂载到cpu上

  ​		训练策略方面：

  ##### （1.3）数据集清理

  中文预训练数据集可以使用 [[悟道](https://link.zhihu.com/?target=https%3A//data.baai.ac.cn/details/WuDaoCorporaText)]，数据集分布如下（主要以百科、博客为主）
  

但开源数据集可以用于实验，如果想突破性能，则需要我们自己进行数据集构建。

在 [[falcon paper](https://link.zhihu.com/?target=https%3A//arxiv.org/pdf/2306.01116.pdf)] 中提到，

  仅使用「清洗后的互联网数据」就能够让模型比在「精心构建的数据集」上有更好的效果

  [【Falcon Paper】我们是靠洗数据洗败 LLaMA 的！ - 知乎](https://zhuanlan.zhihu.com/p/637996787)

  ##### （1.4）模型效果评测

  关于 Language Modeling 的量化指标，较为普遍的有 [[PPL](https://zhuanlan.zhihu.com/p/424162193)]，[[BPC](https://zhuanlan.zhihu.com/p/424162193)] 等，可以简单理解为在生成结果和目标文本之间的 Cross Entropy Loss 上做了一些处理。这种方式可以用来评估模型对「语言模板」的拟合程度，

  ​		大部分 LLM 都具备生成流畅和通顺语句能力，很难比较哪个好，哪个更好。

  **为此，我们需要能够评估另外一个大模型的重要能力 —— 知识蕴含能力**。

  **C-Eval**【中文知识能力测试数据集】

#### **(2) 微调（Finetuning）**

- [ ] **监督微调（SFT）**：用标注数据调整模型行为（如指令跟随）。初步的回答策略

  - 指令微调instruction Tuning：构造一问一答或者多轮问答的数据**<引导大模型的知识[！数据有限引导有限/模型原先的错误或有害没有被纠正，从而出现幻觉或有害性]>**

    指令微调数据集Alpaca、BELLE	

    评价指标比pretrain还让人头疼BLEU 和 ROUGH 指标已经不再客观，一种比较流行的方式是像 [[FastChat](https://link.zhihu.com/?target=https%3A//github.com/lm-sys/FastChat/blob/main/fastchat/eval/table/prompt.jsonl)] 中一样，利用 GPT-4 为模型的生成结果打分

    **为什么还要进行RLHF？？**

    ​        通过构建的训练数据有限，引导大模型知识生成的文本就会存在偏见和不当内容（模型本身也存在错误和有害内容没有被纠正，从而出现幻觉和有害性），无法提供负反馈、无法向后看就无法理解夫扎的上下文和长距离依赖关系

    **1、SFT无法提供负反馈**
    
  - SFT训练是让模型学习条件概率的过程，即监督式学习nexttoken最大化条件概率。能学到什么是正确的nexttoken，但不能学到什么是错误的next token，没有负反馈机制。
    - 正确的文本，它可能有局部是不正确的，这些局部错误的知识内容也会在 SFT 的过程中被模型学到。

    **2、SFT无法“向后看”**
    
    - SFT具有从前到后的单向注意力结构缺陷，每一个 token 都只看得见它前面的 tokens。
  - 前半段错误，后半段在否定前半段的内容。SFT只参考前面信息的情况下，则是一种局部的有偏的训练方法。
    - 通过人类反馈，RLHF可以帮助模型更好地**理解复杂的上下文和长距离依赖关系**。

    **3、减少偏见和不当内容**
    
  - SFT可能会生成带有偏见或不当内容的文本，因为它是从数据中学习语言模式，而数据本身可能包含偏见。
    - RLHF可以通过奖励那些符合社会价值观和伦理标准的行为，减少模型生成带有偏见或不当内容的风险。

    **4、提高安全性和0伦理性**
    
  - 由于SFT缺乏对生成内容的直接控制，可能会导致生成有害、不准确或不适当的内容。
    - RLHF 可以通过人类的监督和反馈来提高模型的安全性和伦理性确保生成的内容是合适的。

    **5、多样性和泛化性对比**
    
    - 在模型的泛化性上，经过RLHF训练之后的效果是要优于只进行SFT阶段的模型。
    - 在生成回复的多样性上，RLHF是要远远弱于SFT的。不管输入如何，经过了RLHF的模型都倾向于产生更相似的回复。

- [ ] **基于人类反馈的强化学习（RLHF）**：

  **最近流行且具有强大能力的大语言模型几乎都利用强化学习（RL）在训练后过程中进一步提升其性能。**

  这些模型采用的强化学习方法通常可以分为**两个主要方向：**

  1. **传统强化学习方法**，如 **RLHF****和 RLAIF**。这些方法需要训练一个**奖励模型**，并涉及复杂且通常不稳定的过程，使用算法如近端策略优化（PPO）来优化策略模型。

  2. **简化方法**，如 **DPO 和****RPO**。这些方法摒弃了奖励模型，提供了一个稳定、高效且计算效率高的解决方案。

     ​	简化方法则不再RLHF中，另外的

  ​        **RLHF** 是一种训练方法，它将**强化学习（RL）与人类反馈**相结合，以使大语言模型（LLMs）与人类的**价值观、偏好和期望**保持一致。

  **RLHF** **主要包括两个组成部分：**

  **（1）收集人类反馈来训练奖励模型**，针对收集的数据标注分数和偏好，训练RM奖励模型（Reward Model），并在强化学习过程中作为奖励函数；

  > ​			✅ 奖励模型（RM）要干什么？**输入一个 prompt + 回答，输出一个“分数”**（reward），表示这个回答有多好（越大越好）。

  **（2）使用人类反馈进行偏好优化，**其中训练好的奖励模型指导LLM输出的优化，以最大化预测奖励，使LLM的行为与人类偏好保持一致。采用**PPO**（或其他 RL 算法）优化语言模型参数，让模型逐步学习生成更高评分的回答。/**DPO**<不使用RM奖励模型（不打分）、不进行强化学习直接训练、>/  |||**BON**<只做了筛选，再重新进行监督微调>

  

  **PPO(RL策略优化算法)**-强化学习算法

  ​       真正的RL执行算法，是一种强化学习中的策略优化算法，用于训练智能体（比如语言模型）在某个环境中**获得更高的“奖励”**。

  ## 🤖 PPO 在 RLHF 中怎么用？

  在 RLHF（比如训练 ChatGPT）里：

  1. 模型先通过 SFT 学会一个初步回答策略。
  2. 然后开始 PPO 训练：
     - **环境**：输入 prompt。
     - **行为（Action）**：生成的回答（token 序列）。
     - **奖励（Reward）**：用人类偏好训练的奖励模型给分。
     - **策略更新**：用 PPO 算法更新模型，使它更倾向于生成高分回答。

  **BON（Best-of-N）是啥？**

  ​    👉 它的做法：

  - 对一个 prompt，生成 **N 个候选输出**（例如 4 个回答）。
  - 通过人类或一个奖励模型对这 N 个输出进行打分或评估。
  - 选出“最好的那个”（Best）。
  - 用这个最优输出进行监督微调，或者直接作为最终输出。
  - 对模型智慧进行一次模型的【采样-迭代】，PPO则多次多模型进行【采样-迭代-进化】

  ### 🚫 特点：

  - **不涉及梯度优化奖励模型的输出**。
  - **不需要强化学习算法**（如 PPO）。
  - 更多是在**训练数据层面做筛选增强**，不是策略优化。

  **DPO是啥？？**<一种带有偏好标签的监督学习过程>

  ​        DPO 不需要采样和在线迭代，而是用离线偏好对数据进行一次性优化，是一种高效、稳定的监督式偏好学习方法。

  🆚 DPO vs RLHF（PPO）

  | 项目         | RLHF                                       | DPO                    |
  | ------------ | ------------------------------------------ | ---------------------- |
  | 数据需求     | 偏好对 + 奖励建模                          | 仅偏好对               |
  | 算法复杂度   | 高（要 PPO、RM）                           | 低（直接监督优化）     |
  | 训练稳定性   | 不稳定                                     | 非常稳定               |
  | 训练时间     | 更久                                       | 更快                   |
  | 效果         | 很好                                       | 通常更好或相当         |
  | 损失函数类型 | 强化学习目标（例如 PPO clipped objective） | logistic 偏好分类 loss |
  | 模型更替     | 采样-迭代-进化                             | 不需要                 |

  ![image-20250424105215974](images\image-20250424105215974.png)

  ####  评估指标Evaluation & Testing

  | 评估维度 | 常用指标                             |
  | :------- | :----------------------------------- |
  | 语言能力 | Perplexity、BLEU、ROUGE              |
  | 推理能力 | GSM8K（数学）、Big-Bench（综合）     |
  | 安全性   | Toxicity Score、Bias Metrics         |
  | 指令跟随 | AlpacaEval、MT-Bench                 |
  | 对齐测试 | 确保模型的输出符合人类的意图和价值观 |

  **自动评估**：使用基准任务（如MMLU、HELLASWAG、GSM8K等）测试模型性能

------

### **3. 生成文本的过程**

当用户输入提示（Prompt）时，模型按以下步骤生成回复：

1. **分词（Tokenization）**：将文本转换为模型可理解的Token 和 token id（如Claude使用字节对编码BPE|wolrdpiece）。

2. **前向传播**：
   
   - Token(embedding 和 position embedding后)通过多层Transformer块处理。
   - 输出每个位置下一个Token的得分（Logits 输出得分）。
   
3. **采样**：
   
   ###### 常用策略包括：
   
   - **贪婪搜索（Greedy）**：直接选择概率最高的Token。
   
   - **束搜索（Beam Search）**：保留多个候选序列。
   
   - **Top-p (nucleus) Sampling**：从累计概率为 p 的 token 中采样
   
     **Temperature**：调整概率分布“陡峭”程度（控制创造力）
   
4. **生成并循环**：

   将生成的 token 加到输入序列末尾，继续预测下一个 token。

   不断循环，直到：

   - 生成了 `[EOS]` 结束标志
   - 达到最大长度
   - 用户设置了 stop token

5. **最终：反 token 化（Detokenization）**

   模型最终生成的是一串 token ID，如 `[713, 4204, 25, 8912]`

   使用分词器反编码为可读文本：`"Bonjour, comment allez-vous ?"`

------

### **4. 关键技术特点**

| 特性              | 说明                                                        |
| :---------------- | :---------------------------------------------------------- |
| **上下文窗口**    | 模型能处理的文本长度上限（如Claude 3支持200K Token）。      |
| **零样本学习**    | 无需示例直接执行新任务（依赖预训练知识）。                  |
| **思维链（CoT）** | 通过分步推理提升复杂问题解答能力（如"让我们一步步思考…"）。 |
| **长程依赖处理**  | 注意力机制理论上支持无限长上下文，但实际受计算资源限制。    |

------

### **5. 局限性**

- **幻觉（Hallucination）**：生成似是而非的错误信息。
- **实时性**：训练数据截止后无法获取新知识（需通过检索增强RAG弥补）。
- **计算成本**：训练需千亿级参数和GPU集群（如GPT-4估计需数千万美元）。

------

### **直观类比理解**

将LLM视为一个**超级文本预测器**：

1. **输入**："法国的首都是"
2. **内部计算**：
   - 分析"法国"与"首都"的统计关联。
   - 从训练数据中回忆类似模式（如"日本的首都是东京"）。
3. **输出**："巴黎"（因"巴黎"在训练数据中与此上下文共现频率最高）。





## 案例

以下是使用Hugging Face的Transformer库运行Llama 3等开源模型的完整指南，包含代码示例和关键注意事项：

------

### **1. 环境准备**

```
# 安装必需库（建议使用Python 3.10+）
pip install torch transformers accelerate sentencepiece
```

------

### **2. 基础模型推理（Llama 3示例）**

#### **(1) 加载8B参数模型（需16GB+显存）**

```
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch

model_id = "meta-llama/Meta-Llama-3-8B"

# 加载模型和分词器
tokenizer = AutoTokenizer.from_pretrained(model_id)
model = AutoModelForCausalLM.from_pretrained(
    model_id,
    torch_dtype=torch.bfloat16,  # 节省显存
    device_map="auto"            # 自动分配GPU/CPU
)

# 生成文本
inputs = tokenizer("法国的首都是", return_tensors="pt").to("cuda")
outputs = model.generate(**inputs, max_new_tokens=50)
print(tokenizer.decode(outputs[0], skip_special_tokens=True))
```

#### **(2) 使用4-bit量化（降低显存需求）**

```
from transformers import BitsAndBytesConfig

quant_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_compute_dtype=torch.float16
)

model = AutoModelForCausalLM.from_pretrained(
    model_id,
    quantization_config=quant_config,
    device_map="auto"
)
```

------

### **3. 关键参数说明**

| 参数             | 作用                                                |
| :--------------- | :-------------------------------------------------- |
| `max_new_tokens` | 控制生成文本的最大长度                              |
| `temperature`    | 值越高输出越随机（默认0.7）                         |
| `top_p`          | 核采样阈值（如0.9表示只从概率累积90%的token中采样） |
| `do_sample`      | 设为True启用随机采样                                |

------

### **4. 流式输出（适合长文本）**

```
from transformers import TextStreamer

streamer = TextStreamer(tokenizer)
inputs = tokenizer("请解释量子计算：", return_tensors="pt").to("cuda")
_ = model.generate(**inputs, streamer=streamer, max_new_tokens=500)
```

------

### **5. 微调模型（以QLoRA为例）**

```
from peft import LoraConfig, prepare_model_for_kbit_training
from transformers import TrainingArguments

# 1. 准备模型
model = prepare_model_for_kbit_training(model)
peft_config = LoraConfig(
    r=8, 
    target_modules=["q_proj", "k_proj"],
    lora_alpha=32,
    lora_dropout=0.05
)

# 2. 训练配置
training_args = TrainingArguments(
    output_dir="./results",
    per_device_train_batch_size=4,
    gradient_accumulation_steps=4,
    learning_rate=2e-5,
    fp16=True
)

# 3. 开始训练（需准备数据集）
trainer = SFTTrainer(
    model=model,
    train_dataset=dataset,
    peft_config=peft_config,
    args=training_args
)
trainer.train()
```

------

### **6. 资源优化技巧**

#### **显存不足时的解决方案**

1. **量化**：

   ```
   model = AutoModelForCausalLM.from_pretrained(model_id, load_in_8bit=True)
   ```

2. **梯度检查点**：

   ```
   model.gradient_checkpointing_enable()
   ```

3. **CPU卸载**：

   ```
   model = dispatch_model(model, device_map="sequential")
   ```

------

### **7. 模型对比（Hugging Face热门模型）**

| 模型名称   | 调用ID                             | 显存需求（推理） | 特点                |
| :--------- | :--------------------------------- | :--------------- | :------------------ |
| Llama 3 8B | `meta-llama/Meta-Llama-3-8B`       | 16GB+            | Meta最新开源模型    |
| Mistral 7B | `mistralai/Mistral-7B-v0.1`        | 12GB+            | 性能优于Llama 2 13B |
| Gemma 2B   | `google/gemma-2b`                  | 5GB+             | 谷歌轻量级模型      |
| Phi-3-mini | `microsoft/Phi-3-mini-4k-instruct` | 4GB+             | 小模型强推理能力    |

### 

[一文读懂多模态大模型：强化学习技术全面解读 SFT、RLHF、RLAIF、DPO - 知乎](https://zhuanlan.zhihu.com/p/19647641182#:~:text=本文从 强化学习如何增强大语言模型（LLMs） 的视角，进行系统性全面解读，涵盖强化学习的 基础知识、流行的RL增强LLMs、基于 奖励模型,的RL技术（RLHF和 RLAIF），以及直接偏好优化（DPO）方法。 其目的旨在能够 根据输出质量获得奖励反馈，从而提高生成内容的 准确性、连贯性和上下文适当性。)

#