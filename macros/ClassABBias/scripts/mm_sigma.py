#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2026 Christoph Maier
# SPDX-License-Identifier: Apache-2.0
"""sigma of a CACE mismatch parameter from the raw .data files of a run:
mm_sigma.py <run dir>/parameters/mm_params [column]   (column 0 = first echoed value, a fraction)"""
import glob, sys, numpy as np
d, col = sys.argv[1], int(sys.argv[2]) if len(sys.argv) > 2 else 0
v = np.array([float(open(f).read().split()[col]) for f in glob.glob(d + "/**/*.data", recursive=True)]) * 100
print(f"{len(v)} runs: mean {v.mean():+.2f} %, sigma {v.std():.2f} %, min {v.min():+.2f} %, max {v.max():+.2f} %")
