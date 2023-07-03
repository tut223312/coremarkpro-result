from pathlib import Path
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np


def extract_result(path: Path):
    with path.open() as f:
        x, y, s = f.readlines()[-1].split()[-3:]

        return float(x), float(y), float(s)


def draw_heatmap(data, row_labels, column_labels, title):
    plt.cla()
    plt.clf()

    plot = sns.heatmap(data, annot=True, linewidths=0.5, fmt='.2f',
                       xticklabels=column_labels, yticklabels=row_labels)
    plt.title(title)
    plt.xlabel('number of workers')
    plt.ylabel('number of cores')

    plot.get_figure().savefig('heatmap/' + title + '.png')


def visualize(category: str):
    result_path = Path("result_" + category)

    data_val, data_sca = [], []
    for i in [1, 4, 16, 64]:
        data_val.append(list())
        data_sca.append(list())
        for j in [1, 4, 16, 64]:
            if i < j:
                data_val[-1].append(-1)
                data_sca[-1].append(-1)
                continue

            x, y, s = extract_result(result_path / f'c{i}w{j}.mark')
            data_val[-1].append(x)
            data_sca[-1].append(s)

    draw_heatmap(np.array(data_val), [1, 4, 16, 64], [1, 4, 16, 64],
                 category + '_Score')
    draw_heatmap(np.array(data_sca), [1, 4, 16, 64], [1, 4, 16, 64],
                 category + '_Scaling')


def main():
    Path('./heatmap').mkdir(exist_ok=True)

    categories = ['a100_with_gcc', 'apollo70_with_gcc',
                  'fx700_with_gcc', 'fx700_with_fcc']

    for category in categories:
        visualize(category)


if __name__ == '__main__':
    main()
