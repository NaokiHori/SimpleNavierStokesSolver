import sys
import numpy as np
import matplotlib
matplotlib.use("Agg")
from matplotlib import pyplot as plt


def load(dname):
    time = np.load("{}/time.npy".format(dname))
    lx   = np.load("{}/lx.npy".format(dname))
    ly   = np.load("{}/ly.npy".format(dname))
    Ra   = np.load("{}/Ra.npy".format(dname))
    Pr   = np.load("{}/Pr.npy".format(dname))
    xc   = np.load("{}/xc.npy".format(dname))
    yc   = np.load("{}/yc.npy".format(dname))
    temp = np.load("{}/temp.npy".format(dname))
    return time, lx, ly, Ra, Pr, xc, yc, temp


if __name__ == "__main__":
    dname = sys.argv[1]
    fname = sys.argv[2]
    time, lx, ly, Ra, Pr, x, y, temp = load(dname)
    # visualise transposed array since my screen is wider
    fig = plt.figure(figsize=(8, 6))
    ax111 = fig.add_subplot(111)
    ax111.contourf(y, x, temp.T, vmin=-0.5, vmax=+0.5, cmap="bwr", levels=101)
    kwrds = {
            "title": "T (t: {:.1f}, Ra: {:.1e}, Pr: {:.1e})".format(time, Ra, Pr),
            "aspect": "equal",
            "xlim": [0.0, ly],
            "ylim": [0.0, lx],
            "xlabel": "y (periodic)",
            "ylabel": "x (wall-bounded)",
            "xticks": np.linspace(0.0, ly, 5),
            "yticks": np.linspace(0.0, lx, 3),
    }
    ax111.set(**kwrds)
    plt.savefig(fname, dpi=300)
    plt.close()

