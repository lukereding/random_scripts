# learning pandas


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

```

Selecting subsets of data:

```python

# get a column
df['A']
df.A

# get more than one column
df.loc[:,['A','B']]
df.iloc[:,1:3]


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

```



Sort a data frame (similar to arrange() in dplyr):

```python

df.sort_values(by='B')

```

Filter a data frame:


```python

df[df.A > 0] # similar to filter(df, A > 0) in R
df[df > 0] # makes all negative NaN

```

Equivalent to %in% in R:

```python
df2 = df.copy()
df2['E'] = ['one', 'one','two','three','four','three']
df2[df2['E'].isin(['two','four'])]

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

To find where NaN values are Use

```python

pd.isnull(df)

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

## reshaping data

The tutorial is [here](http://pandas.pydata.org/pandas-docs/stable/10min.html#reshaping), and I don't understand all of it, but it looks like:

- You can use `df.stack()` to go from wide -> long data, but instead of specifying columns on which to reshape, `pandas` uses indexes for some reason. To make things more complex, there can be multiple, heirarchical indices for a single data frame


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




### some useful methods


`.shift(x)` can be used to shift `x` periods


```{python}

```

## dates

```{python}
dates = pd.date_range('20130101', periods=6)
```
