# learning pandas


```{python}

```

## questions

Why indexes?

## DataFrames

Pass a `numpy` matrix, index, column names:

```{python}
df = pd.DataFrame(np.random.randn(6,4), index=dates, columns=list('ABCD'))
```

Pass a `dict`:


```{python}

df2 = pd.DataFrame({ 'A' : 1.,
                         'B' : pd.Timestamp('20130102'),
                         'C' : pd.Series(1,index=list(range(4)),dtype='float32'),
                         'D' : np.array([3] * 4,dtype='int32'),
                         'E' : pd.Categorical(["test","train","test","train"]),
                         'F' : 'foo' })
```

Viewing / summarizing the data frame:

```{python}

df2.head(10)
df2.tail()

# look at columns, similar to names() in R
df.columns

# get summary for each column
df.describe()

```

Selecting subsets of data:

```{python}

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




```



Sort a data frame (similar to filter() in dplyr):

```{python}

df.sort_values(by='B')

```

Filter a data frame:


```{python}

df[df.A > 0] # similar to filter(df, A > 0) in R

```

Equivalent to %in% in R:

```{python}
df2 = df.copy()
df2['E'] = ['one', 'one','two','three','four','three']
df2[df2['E'].isin(['two','four'])]

```
Changing data frame values in place:


```{python}

df.at[dates[0],'A'] = 0
# or
df.iat[0,1] = 0

# change the values in a column
df.loc[:,'D'] = np.array([5] * len(df))

# make values negative
df2 = df.copy()
df2[df2 > 0] = -df2

```

### some useful methods


```{python}

```

## dates

```{python}
dates = pd.date_range('20130101', periods=6)
```
