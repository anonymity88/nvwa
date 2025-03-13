# -*- coding: utf-8 -*-
import os
import re
import subprocess
import matplotlib.pyplot as plt
from matplotlib_venn import venn3
import venn

def coverage_stat(directory1, directory2):
    A_total_lines, A_covered_lines = 0, 0
    B_total_lines, B_covered_lines = 0, 0
    A_total_branches, A_taken_branches = 0, 0
    B_total_branches, B_taken_branches = 0, 0
    ABsome_cover_lines, only_A_cover_lines, only_B_cover_lines = 0, 0, 0
    ABsome_cover_branches, only_A_cover_branches, only_B_cover_branches = 0, 0, 0


    #获取两个文件夹中的文件列表
    files1 = os.listdir(directory1)
    files2 = os.listdir(directory2)

    #按名称排序，以便正确匹配两个文件夹中的文件
    files1.sort()
    files2.sort()

    #依次处理每一对文件
    for file1, file2 in zip(files1, files2):
        file_path1 = os.path.join(directory1, file1)
        file_path2 = os.path.join(directory2, file2)
        with open(file_path1) as file1, open(file_path2) as file2:
            for linesA, linesB in zip(file1, file2):
                
                if re.match(".*:.*:.*", linesA) and not re.match("^[ ]*-:.*", linesA):
                    A_total_lines += 1
                    if not re.match("    #####:.*", linesA):
                        A_covered_lines += 1
                        if re.match(".*:.*:.*", linesB) and not re.match("^[ ]*-:.*", linesB):
                            if not re.match("    #####:.*", linesB):
                                ABsome_cover_lines += 1
                            elif re.match("    #####:.*", linesB):
                                only_A_cover_lines += 1

                if re.match(".*:.*:.*", linesB) and not re.match("^[ ]*-:.*", linesB):
                    B_total_lines += 1
                    if not re.match("    #####:.*", linesB):
                        B_covered_lines += 1
                        if re.match(".*:.*:.*", linesA) and not re.match("^[ ]*-:.*", linesA):
                            if re.match("    #####:.*", linesA):
                                only_B_cover_lines += 1
                                                                
                #处理分支                
                if re.match("branch  .*", linesA):
                    A_total_branches += 1
                    if re.match("branch  .*taken", linesA):
                        A_taken_branches += 1
                        if re.match("branch  .*", linesB):
                            if re.match("branch  .*taken", linesB):
                                ABsome_cover_branches += 1
                            elif not re.match("branch  .*taken", linesB):
                                only_A_cover_branches += 1

                if re.match("branch  .*", linesB):
                    B_total_branches += 1
                    if re.match("branch  .*taken", linesB):
                        B_taken_branches += 1
                        if re.match("branch  .*", linesA):
                            if not re.match("branch  .*taken", linesA):
                                only_B_cover_branches += 1
                                
    print("A Total Lines: ", A_total_lines)
    print("A Covered Lines: ",A_covered_lines)
    print("A Total Branches: ", A_total_branches)
    print("A Covered Branches: ",A_taken_branches)
    
    print("\nB Total Lines: ", B_total_lines)
    print("B Covered Lines: ",B_covered_lines)
    print("B Total Branches: ", B_total_branches)
    print("B Covered Branches: ",B_taken_branches)

    print("\nThe lines A,B covered both: ", ABsome_cover_lines)
    print("Only A CoverLine: ", only_A_cover_lines)
    print("Only B CoverLine: ", only_B_cover_lines)
    
    print("\nThe Branches A,B covered both: ", ABsome_cover_branches)
    print("Only A CoverBranches: ", only_A_cover_branches)
    print("Only B CoverBranches: ", only_B_cover_branches)
    
    resLines = {'10': only_A_cover_lines, '01': only_B_cover_lines, '11': ABsome_cover_lines}
    mycolor=[[255/255,202/255,212/255,0.3],[170/255,252/255,184/255,0.3],[144/255,224/255,239/255,0.3]]
    # 144,224,239
    # rgba(255,202,212,1)
    # 193,251,164,1
    mycolor1=[[0.10588235294117647, 0.6196078431372549, 0.4666666666666667,0.6],
            [0.9058823529411765, 0.1607843137254902, 0.5411764705882353, 0.6],
            [51/255,160/255,44/255,0.6]]
    fig, ax = venn.venn2(resLines, names = ['MLIRSmith', 'NNSmith (IREE)'],
                        colors=mycolor,
                        # hatch = ['/','/','/'],
                        # alpha=0.7,
                        fontsize=18,#控制组名及中间数字大小
                        # normalize_to=1.0,
                        dpi=72)
    fig.show()
    fig.savefig("vennLines2")
    fig.savefig("vennLines2.png")
    
    resBranches = {'10': only_A_cover_branches, '01': only_B_cover_branches, '11': ABsome_cover_branches}
    fig, ax = venn.venn2(resBranches, names = ['MLIRSmith', 'NNSmith (IREE)'],
                        colors=mycolor,
                        fontsize=18,
                        dpi=72)
    fig.show()
    fig.savefig("vennBranches2")
    fig.savefig("vennBranches2.png")

directory1 = "/home/MLIRSmith11/paper/generated_gcov/MLIRSmith_gcov"
directory2 = "/home/MLIRSmith11/paper/generated_gcov/NNSmith_IREE_gcov"
coverage_stat(directory1, directory2)