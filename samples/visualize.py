import numpy as np
import matplotlib.pyplot as plt
a = np.fromfile('2005d.dat', dtype=np.uint16, offset=68)
plt.plot(a[10:][::4])
plt.savefig("ch1.png")
plt.clf()

plt.plot(a[1:][::4])
plt.savefig("ch2.png")
plt.clf()

plt.plot(a[2:][::4])
plt.savefig("ch3.png")
plt.clf()

plt.plot(a[3:][::4])
plt.savefig("ch4.png")