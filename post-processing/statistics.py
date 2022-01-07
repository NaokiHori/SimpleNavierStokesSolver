import sys
import numpy as np
from matplotlib import pyplot as plt


def load(dname):
    num   = np.load("{}/num.npy".format(dname))
    xf    = np.load("{}/xf.npy".format(dname))
    xc    = np.load("{}/xc.npy".format(dname))
    ux1   = np.load("{}/ux1.npy".format(dname))
    ux2   = np.load("{}/ux2.npy".format(dname))
    uy1   = np.load("{}/uy1.npy".format(dname))
    uy2   = np.load("{}/uy2.npy".format(dname))
    temp1 = np.load("{}/temp1.npy".format(dname))
    temp2 = np.load("{}/temp2.npy".format(dname))
    return num, xf, xc, ux1, ux2, uy1, uy2, temp1, temp2

def average_in_y(data):
    return np.average(data, axis=0)

def compute_rms(data1, data2):
    rms2 = data2-np.power(data1, 2.)
    print("min(rms2): {: .1e}".format(np.min(rms2)))
    rms2[rms2 < 0.] = 0.
    return np.sqrt(rms2)

def save1d(fname, x, data):
    result = np.vstack([x, data]).T
    np.savetxt(fname, result, fmt="% .7e", delimiter=" ")

if __name__ == "__main__":
    # take one argument, input file name
    if len(sys.argv) != 2:
        print("Give directory name to be analysed")
        print("  e.g., python3 visualise.py ../output/stat/step0000004000")
        print("NOTE: relative path w.r.t. this script should be given")
        sys.exit()
    dname = sys.argv[1]
    num, xf, xc, ux1, ux2, uy1, uy2, temp1, temp2 = load(dname)
    temp1 /= num
    ux1   /= num
    uy1   /= num
    temp2 /= num
    ux2   /= num
    uy2   /= num
    temp1 = average_in_y(temp1)
    temp2 = average_in_y(temp2)
    ux1   = average_in_y(ux1  )
    ux2   = average_in_y(ux2  )
    uy1   = average_in_y(uy1  )
    uy2   = average_in_y(uy2  )
    temp2 = compute_rms(temp1, temp2)
    ux2   = compute_rms(ux1, ux2)
    uy2   = compute_rms(uy1, uy2)
    fig = plt.figure()
    ax121 = fig.add_subplot(121)
    ax122 = fig.add_subplot(122)
    ax121.plot(xf, ux1,   label="ux")
    ax121.plot(xc, uy1,   label="uy")
    ax121.plot(xc, temp1, label="temp")
    ax122.plot(xf, ux2,   label="ux")
    ax122.plot(xc, uy2,   label="uy")
    ax122.plot(xc, temp2, label="temp")
    plt.legend()
    plt.show()
    plt.close()

