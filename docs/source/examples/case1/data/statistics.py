import sys
import numpy as np


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

def trunc(arr):
    n = len(arr)
    arr = arr[:n//2+1]
    return arr

def save1d(fname, x, mean, std):
    result = np.vstack([x, mean, std]).T
    np.savetxt(fname, result, fmt="% .7e", delimiter=" ")

if __name__ == "__main__":
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
    temp1 = 0.5*(temp1[:]-temp1[::-1])
    ux1   = 0.5*(ux1[:]+ux1[::-1])
    uy1   = 0.5*(uy1[:]+uy1[::-1])
    temp2 = 0.5*(temp2[:]+temp2[::-1])
    ux2   = 0.5*(ux2[:]+ux2[::-1])
    uy2   = 0.5*(uy2[:]+uy2[::-1])
    xf    = trunc(xf)
    xc    = trunc(xc)
    temp1 = trunc(temp1)
    ux1   = trunc(ux1)
    uy1   = trunc(uy1)
    temp2 = trunc(temp2)
    ux2   = trunc(ux2)
    uy2   = trunc(uy2)
    save1d("stat/temp.dat", xc, temp1, temp2)
    save1d("stat/ux.dat", xf, ux1, ux2)
    save1d("stat/uy.dat", xc, uy1, uy2)

