import tkinter as tk

class MinerUI:
    def __init__(self, miner):
        self.miner = miner
        self.root = tk.Tk()
        self.root.title("Omega Pi Miner")

        # Create labels and entries for miner configuration
        self.hash_rate_label = tk.Label(self.root, text="Hash Rate:")
        self.hash_rate_label.pack()
        self.hash_rate_entry = tk.Entry(self.root)
        self.hash_rate_entry.pack()

        self.difficulty_target_label = tk.Label(self.root, text="Difficulty Target:")
        self.difficulty_target_label.pack()
        self.difficulty_target_entry = tk.Entry(self.root)
        self.difficulty_target_entry.pack()

        self.block_reward_label = tk.Label(self.root, text="Block Reward:")
        self.block_reward_label.pack()
        self.block_reward_entry = tk.Entry(self.root)
        self.block_reward_entry.pack()

        self.transaction_fee_label = tk.Label(self.root, text="Transaction Fee:")
        self.transaction_fee_label.pack()
        self.transaction_fee_entry = tk.Entry(self.root)
        self.transaction_fee_entry.pack()

        # Create button to start mining
        self.start_mining_button = tk.Button(self.root, text="Start Mining", command=self.start_mining)
        self.start_mining_button.pack()

        # Create label to display miner stats
        self.stats_label = tk.Label(self.root, text="Miner Stats:")
        self.stats_label.pack()
        self.stats_text = tk.Text(self.root)
        self.stats_text.pack()

    def start_mining(self):
        # Update miner configuration
        self.miner.hash_rate = int(self.hash_rate_entry.get())
        self.miner.difficulty_target = int(self.difficulty_target_entry.get())
        self.miner.block_reward = int(self.block_reward_entry.get())
        self.miner.transaction_fee = int(self.transaction_fee_entry.get())

        # Start mining
        self.miner.run()

        # Update miner stats
        self.update_stats()

    def update_stats(self):
        # Get miner stats
        stats = self.miner.stats

        # Update stats label
        self.stats_text.delete(1.0, tk.END)
        self.stats_text.insert(tk.END, "Average Hash Rate: {}\n".format(stats.calculate_average_hash_rate()))
        self.stats_text.insert(tk.END, "Average Block Time: {}\n".format(stats.calculate_average_block_time()))
        self.stats_text.insert(tk.END, "Average Transaction Fee: {}\n".format(stats.calculate_average_transaction_fee()))

        # Update stats label every 1 second
        self.root.after(1000, self.update_stats)

    def run(self):
        self.root.mainloop()
