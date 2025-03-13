import matplotlib.pyplot as plt
import numpy as np
import os

def plot_interactions(output_path, line1_data, line2_data):
    """
    Plots two pie charts to represent the proportions of counts from line1_data and line2_data.

    Parameters:
    - output_path: Path to save the PDF.
    - line1_data: List of counts for the first line.
    - line2_data: List of counts for the second line.
    """
    # Remove the last element to exclude the "failures" data
    line1_main = line1_data[:10]
    line2_main = line2_data[:10]

    # Define a custom color palette
    colors = ['#5C6BC0', '#42A5F5', '#66BB6A', '#FFB74D', '#FF7043', '#7E57C2', '#00BCD4', '#F44336', '#9C27B0', '#009688']

    # Create the figure with two subplots and improved spacing
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 7), constrained_layout=True)

    # Plot pie chart for line1_data (without labels next to the pie slices)
    ax1.pie(line1_main, autopct='%1.1f%%', startangle=90, colors=colors, wedgeprops={'edgecolor': 'black', 'linewidth': 1.5})
    ax1.set_title('Generate Proportions', fontsize=18, fontweight='bold', family='serif')

    # Plot pie chart for line2_data (without labels next to the pie slices)
    ax2.pie(line2_main, autopct='%1.1f%%', startangle=90, colors=colors, wedgeprops={'edgecolor': 'black', 'linewidth': 1.5})
    ax2.set_title('Mutate Proportions', fontsize=18, fontweight='bold', family='serif')

    # Add centralized legend
    fig.legend([f"Category {i}" for i in range(1, 11)], loc="center", fontsize=12, title="Categories", ncol=5)

    # Ensure the output directory exists
    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    # Save the figure
    plt.savefig(output_path, format="pdf")
    plt.close()

# Example usage
line1_data = [79, 14, 4, 1, 0, 0, 0, 0, 0, 2, 20]  # Replace with your data
line2_data = [68, 17, 5, 3, 1, 2, 1, 3, 0, 0, 45]   # Replace with your data
output_path = "test/interactions_pie_charts.pdf"

plot_interactions(output_path, line1_data, line2_data)
