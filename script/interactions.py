import matplotlib.pyplot as plt
import os
import numpy as np

def plot_interactions(output_path, line1_data, line2_data):
    """
    Plots a bar chart with interactions on the x-axis and case values on the y-axis.
    The y-axis range is determined automatically based on the input data.

    Parameters:
    - output_path: Path to save the PDF.
    - line1_data: List of counts for the "Generate" category.
    - line2_data: List of counts for the "Mutate" category.
    """
    # Define x-axis labels and positions
    x_labels = [str(i) for i in range(1, 11)]
    x_positions = np.arange(1, 11)  # x-axis positions from 1 to 10

    # Set individual bar width and position offsets for grouping
    bar_width = 0.4

    # Create the figure and axis
    fig, ax = plt.subplots(figsize=(8, 6))
    
    # Plot the bar charts for the two lines
    ax.bar(x_positions - bar_width/2, line1_data, width=bar_width, label="Generate")
    ax.bar(x_positions + bar_width/2, line2_data, width=bar_width, label="Mutate")

    # Customize the x-axis
    ax.set_xticks(x_positions)
    ax.set_xticklabels(x_labels, rotation=0, ha="center")
    ax.set_xlabel("Interactions", fontsize=30)

    # Set y-axis title as required.
    ax.set_ylabel("Case Ratio(%)", fontsize=28)
    
    # 自动确定y轴范围：以数据最大值为基础，留出10%的余量
    max_value = max(max(line1_data), max(line2_data))
    ax.set_ylim(0, max_value * 1.1)

    # Tick parameters and legend (legend moved to the upper right)
    ax.tick_params(axis='both', labelsize=25)
    ax.legend(loc='upper right', fontsize=30)

    # Add grid
    ax.grid(visible=True, linestyle="--", alpha=0.7)

    # Ensure the output directory exists
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    # Save the figure
    plt.tight_layout()
    plt.savefig(output_path, format="pdf")
    plt.close()

# Example usage
line1_data = [79, 14, 4, 1, 0, 0, 0, 0, 0, 2]  # Replace with your data
line2_data = [68, 17, 8, 2, 1, 2, 1, 1, 0, 0]   # Replace with your data
output_path = "test/interactions.pdf"

plot_interactions(output_path, line1_data, line2_data)