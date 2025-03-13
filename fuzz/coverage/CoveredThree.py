# -*- coding: utf-8 -*-
import os
import re
import subprocess
import matplotlib.pyplot as plt
from matplotlib_venn import venn3,venn3_circles
import venn


def coverage_stat(directory1, directory2, directory3):
    A_total_lines, A_covered_lines = 0, 0
    B_total_lines, B_covered_lines = 0, 0
    C_total_lines, C_covered_lines = 0, 0
    A_total_branches, A_taken_branches = 0, 0
    B_total_branches, B_taken_branches = 0, 0
    C_total_branches, C_taken_branches = 0, 0
    some_cover_lines, ABsome_cover_lines, BCsome_cover_lines, ACsome_cover_lines, only_A_cover_lines, only_B_cover_lines, only_C_cover_lines = 0, 0, 0, 0, 0, 0, 0
    some_cover_branches, ABsome_cover_branches, BCsome_cover_branches, ACsome_cover_branches, only_A_cover_branches, only_B_cover_branches, only_C_cover_branches = 0, 0, 0, 0, 0, 0, 0


    #获取两个文件夹中的文件列表
    files1 = os.listdir(directory1)
    files2 = os.listdir(directory2)
    files3 = os.listdir(directory3)

    #按名称排序，以便正确匹配两个文件夹中的文件
    files1.sort()
    files2.sort()
    files3.sort()

    #依次处理每一对文件
    for file1, file2, file3 in zip(files1, files2, files3):
        file_path1 = os.path.join(directory1, file1)
        file_path2 = os.path.join(directory2, file2)
        file_path3 = os.path.join(directory3, file3)
        with open(file_path1) as file1, open(file_path2) as file2, open(file_path3) as file3:
            for linesA, linesB, linesC in zip(file1, file2, file3):
                
                if re.match(".*:.*:.*", linesA) and not re.match("^[ ]*-:.*", linesA):
                    A_total_lines += 1
                    if not re.match("    #####:.*", linesA):
                        A_covered_lines += 1
                        if re.match(".*:.*:.*", linesB) and not re.match("^[ ]*-:.*", linesB) and re.match(".*:.*:.*", linesC) and not re.match("^[ ]*-:.*", linesC):
                            if not re.match("    #####:.*", linesB) and not re.match("    #####:.*", linesC):
                                some_cover_lines += 1
                            elif re.match("    #####:.*", linesB) and not re.match("    #####:.*", linesC):
                                ACsome_cover_lines += 1
                            elif not re.match("    #####:.*", linesB) and re.match("    #####:.*", linesC):
                                ABsome_cover_lines += 1
                            elif re.match("    #####:.*", linesB) and re.match("    #####:.*", linesC):
                                only_A_cover_lines += 1

                if re.match(".*:.*:.*", linesB) and not re.match("^[ ]*-:.*", linesB):
                    B_total_lines += 1
                    if not re.match("    #####:.*", linesB):
                        B_covered_lines += 1
                        if re.match(".*:.*:.*", linesA) and not re.match("^[ ]*-:.*", linesA) and re.match(".*:.*:.*", linesC) and not re.match("^[ ]*-:.*", linesC):
                            if re.match("    #####:.*", linesA) and re.match("    #####:.*", linesC):
                                only_B_cover_lines += 1
                            elif re.match("    #####:.*", linesA) and not re.match("    #####:.*", linesC):
                                BCsome_cover_lines += 1
                
                if re.match(".*:.*:.*", linesC) and not re.match("^[ ]*-:.*", linesC):
                    C_total_lines += 1
                    if not re.match("    #####:.*", linesC):
                        C_covered_lines += 1
                        if re.match(".*:.*:.*", linesA) and not re.match("^[ ]*-:.*", linesA) and re.match(".*:.*:.*", linesB) and not re.match("^[ ]*-:.*", linesB):
                            if re.match("    #####:.*", linesA) and re.match("    #####:.*", linesB):
                                only_C_cover_lines += 1
                                
                                
                                
                #处理分支                
                if re.match("branch  .*", linesA):
                    A_total_branches += 1
                    if re.match("branch  .*taken", linesA):
                        A_taken_branches += 1
                        if re.match("branch  .*", linesB) and re.match("branch  .*", linesC):
                            if re.match("branch  .*taken", linesB) and re.match("branch  .*taken", linesC):
                                some_cover_branches += 1
                            elif re.match("branch  .*taken", linesB) and not re.match("branch  .*taken", linesC):
                                ABsome_cover_branches += 1
                            elif not re.match("branch  .*taken", linesB) and re.match("branch  .*taken", linesC):
                                ACsome_cover_branches += 1
                            elif not re.match("branch  .*taken", linesB) and not re.match("branch  .*taken", linesC):
                                only_A_cover_branches += 1

                
                if re.match("branch  .*", linesB):
                    B_total_branches += 1
                    if re.match("branch  .*taken", linesB):
                        B_taken_branches += 1
                        if re.match("branch  .*", linesA) and re.match("branch  .*", linesC):
                            if not re.match("branch  .*taken", linesA) and not re.match("branch  .*taken", linesC):
                                only_B_cover_branches += 1
                            elif not re.match("branch  .*taken", linesA) and re.match("branch  .*taken", linesC):
                                BCsome_cover_branches += 1

                if re.match("branch  .*", linesC):
                    C_total_branches += 1
                    if re.match("branch  .*taken", linesC):
                        C_taken_branches += 1
                        if re.match("branch  .*", linesA) and re.match("branch  .*", linesB):
                            if not re.match("branch  .*taken", linesA) and not re.match("branch  .*taken", linesB):
                                only_C_cover_branches += 1
                                
                                
                                
                

    print("A Total Lines: ", A_total_lines)
    print("A Covered Lines: ",A_covered_lines)
    print("A Total Branches: ", A_total_branches)
    print("A Covered Branches: ",A_taken_branches)
    
    print("\nB Total Lines: ", B_total_lines)
    print("B Covered Lines: ",B_covered_lines)
    print("B Total Branches: ", B_total_branches)
    print("B Covered Branches: ",B_taken_branches)
    
    print("\nC Total Lines: ", C_total_lines)
    print("C Covered Lines: ",C_covered_lines)
    print("C Total Branches: ", C_total_branches)
    print("C Covered Branches: ",C_taken_branches)
    

    print("\nThe lines A,B,C covered all: ", some_cover_lines)
    print("The lines A,B covered both: ", ABsome_cover_lines)
    print("The lines B,C covered both: ", BCsome_cover_lines)
    print("The lines A,C covered both: ", ACsome_cover_lines)
    print("Only A CoverLine: ", only_A_cover_lines)
    print("Only B CoverLine: ", only_B_cover_lines)
    print("Only C CoverLine: ", only_C_cover_lines)
    
    print("\nThe Branches A,B,C covered all: ", some_cover_branches)
    print("The Branches A,B covered both: ", ABsome_cover_branches)
    print("The Branches B,C covered both: ", BCsome_cover_branches)
    print("The Branches A,C covered both: ", ACsome_cover_branches)
    print("Only A CoverBranches: ", only_A_cover_branches)
    print("Only B CoverBranches: ", only_B_cover_branches)
    print("Only C CoverBranches: ", only_C_cover_branches)
  
    
    #venn图各部分按照比例呈现
    # venn3(subsets = {'100': only_A_cover_lines, '010': only_B_cover_lines, '001': only_C_cover_lines, '110': ABsome_cover_lines, '101': ACsome_cover_lines, '011': BCsome_cover_lines, '111': some_cover_lines}, 
    #       set_labels = ('My Set 1', 'My Set 2', 'My Set 3'))
    # plt.savefig('sinc.png', c = 'c')
    

    # subsets = [{1,2,7,3},{1,2,8,4},{1,2,9,5}]
    # g=venn3(subsets,
    #         set_labels = ('Label 1', 'Label 2','Label 3'),
    #         set_colors=("white", "white", "white"),
    #         alpha=0.8,
    #         # normalize_to=1.0,
    #        )

    resLines = {'100': only_A_cover_lines, '010': only_B_cover_lines, '001': only_C_cover_lines, '110': ABsome_cover_lines, '101': ACsome_cover_lines, '011': BCsome_cover_lines, '111': some_cover_lines}
        # c1='#e52628'
        # c2='#1f78b4'
        # c3='#33a02c'
        #  colors=mycolor
    mycolor=[[255/255,202/255,212/255,0.3],[170/255,252/255,184/255,0.3],[144/255,224/255,239/255,0.3]]
    # 144,224,239
    # rgba(255,202,212,1)
    # 193,251,164,1
    mycolor1=[[0.10588235294117647, 0.6196078431372549, 0.4666666666666667,0.6],
            [0.9058823529411765, 0.1607843137254902, 0.5411764705882353, 0.6],
            [51/255,160/255,44/255,0.6]]
    fig, ax = venn.venn3(resLines, names = ['MLIRSmith', 'NNSmith (IREE)', 'NNSmith (ONNX-MLIR)'],
                        colors=mycolor,
                        # hatch = ['/','/','/'],
                        # alpha=0.7,
                        fontsize=18,#控制组名及中间数字大小
                        # normalize_to=1.0,
                        dpi=72)
    fig.show()
    fig.savefig("vennLines")
    fig.savefig("vennLines.png")
    
    
    resBranches= {'100': only_A_cover_branches, '010': only_B_cover_branches, '001': only_C_cover_branches, '110': ABsome_cover_branches, '101': ACsome_cover_branches, '011': BCsome_cover_branches, '111': some_cover_branches}
    fig, ax = venn.venn3(resBranches, names = ['MLIRSmith', 'NNSmith (IREE)', 'NNSmith (ONNX-MLIR)'],
                        colors=mycolor,
                        fontsize=18,
                        dpi=72)
    fig.show()
    fig.savefig("vennBranches")
    fig.savefig("vennBranches.png")


directory1 = "/home/MLIRSmith11/paper/generated_gcov/MLIRSmith_gcov"
directory2 = "/home/MLIRSmith11/paper/generated_gcov/NNSmith_IREE_gcov"
directory3 = "/home/MLIRSmith11/paper/generated_gcov/NNSmith_ONNX-MLIR_gcov"
coverage_stat(directory1, directory2, directory3)