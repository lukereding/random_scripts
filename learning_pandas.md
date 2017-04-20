# learning pandas

[Great resource](http://nbviewer.jupyter.org/github/pybokeh/jupyter_notebooks/blob/master/pandas/PandasCheatSheet.ipynb)
[using pipes in pandas](http://pandas.pydata.org/pandas-docs/stable/basics.html#tablewise-function-application) (note that pandas calls this _method chaining_)

```python

```

## questions

Why indexes?

## DataFrames

Pass a `numpy` matrix, index, column names:

```python
df = pd.DataFrame(np.random.randn(6,4), index=dates, columns=list('ABCD'))
```

Pass a `dict`:


```python

df2 = pd.DataFrame({ 'A' : 1.,
                         'B' : pd.Timestamp('20130102'),
                         'C' : pd.Series(1,index=list(range(4)),dtype='float32'),
                         'D' : np.array([3] * 4,dtype='int32'),
                         'E' : pd.Categorical(["test","train","test","train"]),
                         'F' : 'foo' })
```

Viewing / summarizing the data frame:

```python

df2.head(10)
df2.tail()

# look at columns, similar to names() in R
df.columns

# get summary for each column
df.describe()

# get information on each column
df.info()

```

Selecting subsets of data:

```python

# get a column
df['A']
df.A

# get more than one column
df.loc[:,['A','B']]
df.iloc[:,1:3]
df.filter(like = "A") # this would also grab a column called Accordian if it was present in the data frame


# get row(s)
df[-1:]
df['20130102':'20130104']
df.iloc[0] # get first row, transposed?
df.iloc[1:3,:]

# get specific rows _and_ columns
# by name:
df.loc['20130102':'20130104',['A','B']]
# by index
df.iloc[3:5,0:2]
# can also pass a list of indicies
df.iloc[[1,2,4],[0,2]]


## get a specific value / cell entry
df.iloc[1,1]
df.iat[1,1]
df.loc[dates[0],'A']
df.at[dates[0],'A']


# delete columns
del df['A']
# or
df.drop('A', axis = 'columns', inplace = True)
df.drop(['A', 'B'], axis = 1, inplace = True) # same thing
```



Sort a data frame (similar to arrange() in dplyr):

```python

df.sort_values(by='B')

# more advanced
data = pd.DataFrame({'group': ['a', 'a', 'a', 'b','b', 'b', 'c', 'c','c'],
                 'ounces': [4, 3, 12, 6, 7.5, 8, 3, 5, 6]})

# sorts values in place, by group and then by ounches within each group, in-place
data.sort_values(by=['group','ounces'], ascending=[False, True], inplace=True)

## Sort by column indices
frame = pd.DataFrame({'b': [4, 7, -3, 2], 'a': [0, 1, 0, 1]})
frame.sort_index(by = 'b')
frame.sort_index(by=['a', 'b'])

```

Filter a data frame:


```python

df[df.A > 0] # similar to filter(df, A > 0) in R
df[df > 0] # makes all negative NaN

# also
iris = pd.read_csv('iris.csv')
iris.query('SepalLength > 5')
iris.query('SepalLength > 5 | SepalWidth > 0.5')


```

Equivalent to %in% in R:

```python
df2 = df.copy()
df2['E'] = ['one', 'one','two','three','four','three']
df2[df2['E'].isin(['two','four'])]
df2[df2.E.str.contains("tw|ou")] # to match based on the name of the column

```

Changing data frame values in place:


```python

df.at[dates[0],'A'] = 0
# or
df.iat[0,1] = 0

# change the values in a column
df.loc[:,'D'] = np.array([5] * len(df))

# make values negative
df2 = df.copy()
df2[df2 > 0] = -df2

```

Similar to R, you can add columns to a data frame if it has the same length:

```python

s1 = pd.Series([1,2,3,4,5,6], index=pd.date_range('20130102', periods=6))
df['F'] = s1


```

Assigning values in a data frame:

```python

df.at[dates[0],'A'] = 0
df.iat[0,1] = 0
df.loc[:,'D'] = np.array([5] * len(df))

```

## missing data

To drop rows with any NaN values, use

```python
df.dropna(how = 'any')
```

To replace missing data

```python
df.fillna(value = 5)
```

To find where NaN values are use

```python

pd.isnull(df)

pd.notnull(df)

df.isnull()

# also see
df.isnull().any(axis=1)

```

## stats

Find the mean for each column of a data frame (this is sort of like using `apply`ing the mean function across columns in R)

```{python}
df.mean()
```

or across rows

```{python}
df.mean(1)
```

To substitute data frames from each other, use `df.sub(other_df)`. You can also substitute objects with different shapes:

```python
s = pd.Series([1,3,5,np.nan,6,8], index=dates).shift(2)

df.sub(s, axis = 'index')

```

You can also `apply` functions similar to `apply` or `map` in R:

```python
# get the range for each column
df.apply(lambda x: x.max() - x.min())

# get the range for each row
df.apply(lambda x: x.max() - x.min(), axis = 1)

def f(x):
	return Series([x.min(), x.max()], index=['min', 'max'])
df.apply(f)

```

## working with strings

```python
s = pd.Series(['A', 'B', 'C', 'Aaba', 'Baca', np.nan, 'CABA', 'dog', 'cat'])

s.str.lower() # make all lowercase
s.str.upper() # make all uppercase

s.str.count("A") # count the number of A's in each string

s.str.contains("ab") # return T if string contains "ab"

```

Other useful methods, which you can guess what they do:
- `s.str.endswith`
- `s.str.islower`
- `s.str.isdigit`
- `s.str.lstrip`
- `s.str.zfill`

## merging

```python
df = pd.DataFrame(np.random.randn(10, 4))

pieces = [df[:3], df[3:7], df[7:]]

pd.concat(pieces)

```

## adding rows

In R, you might use `bind_rows()`:

```python
df = pd.DataFrame(np.random.randn(8, 4), columns=['A','B','C','D'])

# grab the 4th row
s = df.iloc[3]

# add it to the bottom, creating a new index for the 'new' row
df.append(s, ignore_index=True)
```

## grouping data

Like in `dplyr` in R, in `pandas` you can group parts of the data frame together to do certain operations on subsets of the data.


```python
df = pd.DataFrame({'A' : ['foo', 'bar', 'foo', 'bar',
                              'foo', 'bar', 'foo', 'foo'],
                       'B' : ['one', 'one', 'two', 'three',
                              'two', 'two', 'one', 'three'],
                       'C' : np.random.randn(8),
                       'D' : np.random.randn(8)})

df.groupby('A').sum() # get the sum for each value of A across each of the numeric columns

df.groupby('A').apply(lambda x: x.max() - x.min())

```

You can also `groupby` a function:


```python
df = pd.DataFrame({'A' : ['foo', 'bar', 'foo', 'bar',
                              'foo', 'bar', 'foo', 'foo'],
                       'B' : ['one', 'one', 'two', 'three',
                              'two', 'two', 'one', 'three'],
                       'C' : np.random.randn(8),
                       'D' : np.random.randn(8)})

def get_letter_type(letter):
        if letter.lower() in 'aeiou':
            return 'vowel'
        else:
            return 'consonant'

grouped = df.groupby(get_letter_type, axis=1)

```


## reshaping data

The tutorial is [here](http://pandas.pydata.org/pandas-docs/stable/10min.html#reshaping), and I don't understand all of it, but it looks like:

- You can use `df.stack()` to go from wide -> long data, but instead of specifying columns on which to reshape, `pandas` uses indexes for some reason. To make things more complex, there can be multiple, heirarchical indices for a single data frame

Note that when plotting with python, reshaping data from wide to long might not be a big deal because many plotting library, including bokeh, expect the data in a pandas-like wide format.

An example:


```python

import matplotlib.pyplot as plt
from pandas_datareader import data as web
from datetime import datetime
import pandas as pd

stocks = {'tech':['GOOGL', 'MSFT', 'LNKD', 'YHOO', 'FB','HPQ','AMZN'],
          'auto':['TM','F','GM','HMC','NSANY','HYMTF'],
          'housing':['HD','WMT','LOW']
          }

start_date = datetime(2016,1,1)
end_date = datetime(2016, 4, 21)

def get_px(stock, start, end):
    return web.get_data_yahoo(stock, start, end)['Adj Close']

df = pd.DataFrame({n: get_px(n, start_date, end_date) for n in stocks['tech']})


# wide format
df.head(10)

```

We can use `pd.melt` to put the data into long form:


```python

df_long = pd.melt(df, id_vars=['Date']).dropna()

# rename columns
df_long.rename(columns={'variable': 'Stock', 'value':'Price'},inplace=True)


# back to wide format

pivoted = df_long.pivot(index='Date', columns='Stock', values='Price')


```



## dealing with factors (`Categoricals`)

```python
df = pd.DataFrame({"id":[1,2,3,4,5,6], "raw_grade":['a', 'b', 'b', 'a', 'a', 'e']})

df.dtypes

 df["grade"] = df["raw_grade"].astype("category")

 df.dtypes

 # rename factor levels happens in-place)
 df["grade"].cat.categories = ["very good", "good", "very bad"]
df

# add in missing factor levels
df["grade"] = df["grade"].cat.set_categories(["very bad", "bad", "medium", "good", "very good"])
df


df.sort_values(by="grade")

# get the counts of the number of observations in each category
df.groupby("grade").size()


```

## similar to `tally()` in R


```python

data = pd.DataFrame({'group': ['a', 'a', 'a', 'b','b', 'b', 'c', 'c','c'],
                 'ounces': [4, 3, 12, 6, 7.5, 8, 3, 5, 6]})
data.group.value_counts()

```

## df %>% group_by(x) %>% summarise (or tally())

Pandas has a slightly different way of approaching this common routine. Pandas uses `pivot_table`s instead. Because I use this sort of routine so often I'm going to devote a lot of space here to pivot tables. Part of what's confusing to me about pivot tables is that the data are presented in wide, not long, format.

Starting simple:

```python
data = pd.DataFrame({'group': ['a', 'a', 'a', 'b','b', 'b', 'c', 'c','c'],
                 'ounces': [4, 3, 12, 6, 7.5, 8, 3, 5, 6]})

data.pivot_table(values='ounces',index='group',aggfunc=np.mean)

```

This is like, in R, running:


```r
data %>%
    group_by(group) %>%
    summarise(ounces = mean(ounces))

```

Another common routine in dplyr is to do

```r
data %>%
    group_by(group) %>%
    tally

```

to get the number of observations in each group.

In pandas, the equivalent code is:


```python

data.pivot_table(values='ounces',index='group',aggfunc='count')
Out[5]:


```




These examples are based on [this](http://pbpython.com/pandas-pivot-table-explained.html) tutorial.

```python

# ! wget http://pbpython.com/extras/sales-funnel.xlsx
df = pd.read_excel("../in/sales-funnel.xlsx")
df.head()

# make status a categorical variable
df["Status"] = df["Status"].astype("category")
df["Status"].cat.set_categories(["won","pending","presented","declined"],inplace=True)

# the default pivot table function is to take a mean
# this groups the dataframe by manager and rep and gets the average price for each
# this is like doing `df %>% group_by(Manager, Rep) %>% summarise(price = mean(price))` in R
pd.pivot_table(df,index=["Manager","Rep"],values=["Price"])

# we can supply over functions using the aggfunc argument

pd.pivot_table(df,index=["Manager","Rep"],values=["Price"],aggfunc=np.sum)

# the aggfunc argument can also takes lists of functions

pd.pivot_table(df,index=["Manager","Rep"],values=["Price"],aggfunc=[np.mean,len])


# adding columns to the columns arguments make the dataframe wider. You can acheive the same results in a long format by moving the column name to the index

pd.pivot_table(df,index=["Manager","Rep"],values=["Price"],
               columns=["Product"],aggfunc=[np.sum])

pd.pivot_table(df,index=["Manager","Rep"],values=["Price"],columns=["Product"],aggfunc=[np.sum],fill_value=0)

# A really handy feature is the ability to pass a dictionary to the aggfunc so you can perform different functions on each of the values you select. This has a side-effect of making the labels a little cleaner.

pd.pivot_table(df,index=["Manager","Status"],columns=["Product"],values=["Quantity","Price"], aggfunc={"Quantity":len,"Price":np.sum},fill_value=0)


# more advanced:

table = pd.pivot_table(df,index=["Manager","Status"],columns=["Product"],values=["Quantity","Price"],
               aggfunc={"Quantity":len,"Price":[np.sum,np.mean]},fill_value=0)
table

```

Pivot tables are standard data frames, so filtering operations work on pivot tables just like data frames:

```python

table.query('Manager == ["Debra Henley"]')
table.query('Status == ["pending","won"]')





```



## similar to `mutate`


```python

df = pd.DataFrame(
         {'AAA' : [4,5,6,7], 'BBB' : [10,20,30,40],'CCC' : [100,50,-30,-50]}); df

# create new column in df based on other columns
# in R, this might look like df %>% mutate(logic = ifelse(AAA > 5, 'high', 'low'))

df['logic'] = np.where(df['AAA'] > 5,'high','low'); df

# also:

df = pd.DataFrame.from_items([('A', [1, 2, 3]), ('B', [4, 5, 6])],
                            orient='index', columns=['one', 'two', 'three'])
df['four'] = df['two'] * df['three']
df['five'] = df['one'] > 2

## maybe most relevant
# wget https://raw.githubusercontent.com/pandas-dev/pandas/master/pandas/tests/data/iris.csv
iris = pd.read_csv('data/iris.csv')
iris.head()
(iris.assign(sepal_ratio = iris['SepalWidth'] / iris['SepalLength'])
      .head())
# or, equivalently
iris.assign(sepal_ratio = lambda x: (x['SepalWidth']/
x['SepalLength'])).head()

# a different example using a lambda function
df = pd.DataFrame({'A': range(1, 11), 'B': np.random.randn(10)})
df.assign(ln_A = lambda x: np.log(x.A))


### another example
data = pd.DataFrame({'food': ['bacon', 'pulled pork', 'bacon', 'Pastrami','corned beef', 'Bacon', 'pastrami', 'honey ham','nova lox'],
                 'ounces': [4, 3, 12, 6, 7.5, 8, 3, 5, 6]})

# create dict for new column
meat_to_animal = {
'bacon': 'pig',
'pulled pork': 'pig',
'pastrami': 'cow',
'corned beef': 'cow',
'honey ham': 'pig',
'nova lox': 'salmon'
}


def meat2animal(series):
    if series["food"]=='bacon':
        return 'pig'
    elif series["food"]=='pulled pork':
        return 'pig'
    elif series["food"]=='pastrami':
        return 'cow'
    elif series["food"]=='corned beef':
        return 'cow'
    elif series["food"]=='honey ham':
        return 'pig'
    else:
        return 'salmon'
data['animal2'] = data.apply(meat2animal,axis='columns')


```

Note that using `.assign` returns a copy of the data, leaving the original data frame unchanged


## dates

```{python}
dates = pd.date_range('20130101', periods=6)
```


### some useful methods / random useful things


`.shift(x)` can be used to shift `x` periods


```{python}

```

The `~` operator can be used to tae a subset of a mask:


```python

df[~((df.AAA <= 6) & (df.index.isin([0,2,4])))]

```

## chaining together operations in a pipeline-esque series

This is very similar to analysis pipelines in R using dplyr:

```python

(iris.query('SepalLength > 5') # filter
         .assign(SepalRatio = lambda x: x.SepalWidth / x.SepalLength,
                 PetalRatio = lambda x: x.PetalWidth / x.PetalLength) # mutate
         .plot(kind='scatter', x='SepalRatio', y='PetalRatio')) # plot

```

Another example:


```python
# using pandas syntax
(diamonds.assign(carat_diff=diamonds
                 .groupby('color')['carat']
                 .transform(lambda x:x-x.mean())
                )
                .sort_values(by=['color','carat_diff'])
                .head(10)
)


# Using dplyr/dplython syntax
(diamonds >>
  group_by(X.color) >>
  mutate(carat_diff = X.carat - X.carat.mean()) >>
  ungroup() >>
  arrange(X.color, X.carat_diff) >>
  head(10)
)

```

Unlike in `dplyr`, you can't use `mutate` a new variable you created in the same call to `mutate`. So

```python

(df.assign(C = lambda x: x['A'] + x['B'])
          .assign(D = lambda x: x['A'] + x['C']))

```
is fair game but

```python

df.assign(C = lambda x: x['A'] + x['B'],
                  D = lambda x: x['A'] + x['C'])

```

isn't.


We can replicate R's `expand_grid` function ike this in Python:


```python

def expand_grid(data_dict):
       rows = itertools.product(*data_dict.values())
       return pd.DataFrame.from_records(rows, columns=data_dict.keys())
df = expand_grid(
              {'height': [60, 70],
               'weight': [100, 140, 180],
               'sex': ['Male', 'Female']})

```


Drop duplicates:


```python
data.drop_duplicates()
```

Replace some number with NaNs:


```python
data = pd.Series([1., -999., 2., -999., -1000., 3.])
data.replace(-999, np.nan, inplace=True)
data.replace([-999, -1000], np.nan, inplace=True)


```

Dropping rows that have missing data:


```python

data.dropna()

```

Replace NaNs with some other number:


```python
data.dropna(value = 10)
```

Renaming columns and/or indices:


```python

data = pd.DataFrame(np.arange(12).reshape((3, 4)),index=['Ohio', 'Colorado', 'New York'],columns=['one', 'two', 'three', 'four'])

data.rename(index={'Ohio': 'INDIANA'},columns={'three': 'peekaboo'},inplace=True)

```

Binning a continuous variable into categories:


```python

ages = [20, 22, 25, 27, 21, 23, 37, 31, 61, 45, 41, 32]
bins = [18, 25, 35, 60, 100]

group_names = ['Youth', 'YoungAdult', 'MiddleAged', 'Senior']
pd.cut(ages, bins, labels=group_names)
cats.levels
cats.labels

pd.value_counts(pd.cut(ages, bins, labels=group_names))


```

Set the index to one of the columns:


```python

data = data.set_index('a') # to set column a as the index

```

Example to study on method chaining or using pipes:


```python

df = (pd.read_csv('/home/pybokeh/temp/vehicles.csv',
                 usecols=['year', 'make', 'model', 'comb08', 'fuelType', 'fuelType1',
                          'fuelType2', 'atvType', 'cylinders', 'VClass'])
      .rename(columns={'comb08':'combmpg'})
      .query("make in('Honda','Acura','Toyota','Lexus') "
             "& fuelType1 in('Regular Gasoline','Premium Gasoline','Midgrade Gasoline') "
             "& cylinders in(4, 6) "
             "& VClass in('Compact Cars','Subcompact Cars','Midsize Cars','Large Cars','Sport Utility','Minivan') "
             "& ~(fuelType2 in('E85','Electricity','Natural Gas','Propane'))")
      ['combmpg'].plot.hist(alpha=0.5, label='Honda Motor Co')
     )

```

------------

You can think of a `pd.Series` as a vector. You can do vector-like operations with Series and can think about them as a column in a data frame.
