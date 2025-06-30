# 🏢 RealEstate Smart Contract

A simple real estate decentralized application (dApp) built with Solidity. Users can rent different types of apartments (Studio, One-Bedroom, Two-Bedroom) using Ether, and the contract tracks available, rented, and total apartments. The contract also allows the owner to pause renting, add/remove apartments, and manage active rentals.

---

## 🔧 Features

- Apartment rental system using Ether
- Three apartment types:
  - Studio (1 ETH/year)
  - One-Bedroom (1.6 ETH/year)
  - Two-Bedroom (2 ETH/year)
- Rent duration is fixed at **365 days**
- Cancel rent with a **10% fee**
- Admin-only controls to pause/resume rentals and manage listings
- Event hooks for staking/renting logic

---



## 💸 Pricing

| Apartment Type | Cost (ETH/year) |
|----------------|------------------|
| Studio         | 1.0 ETH          |
| One Bedroom    | 1.6 ETH          |
| Two Bedroom    | 2.0 ETH          |

Cancellation incurs a 10% fee on remaining rent.

---

## 📜 License

This project is licensed under the [MIT License](./LICENSE)

