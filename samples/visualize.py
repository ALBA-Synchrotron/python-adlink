import numpy as np
import matplotlib.pyplot as plt
a = np.fromfile('2005d.dat.dat', dtype=np.uint16, offset=68)
plt.plot(a[10:][::4])
plt.savefig("sinus.png")
plt.show()
