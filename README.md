# Beauty Salon Management System (BSMS)


## Overview

The **Beauty Salon Management System (BSMS)** is a comprehensive software solution designed to streamline operations for beauty salons. This system enhances customer experience and improves business efficiency by digitizing salon processes such as customer registration, appointment scheduling, product purchases, and more.


## Features

### User Management

- **User Registration** with various options (email/phone and third-party integrations like Google and Apple).

- **Profile Management** for customers and staff, including role-specific access.

- **Two-Factor Authentication (2FA)** for enhanced security.


- **Appointment Management**

  - Book, modify, and cancel appointments.

  - Option to select specific staff members for appointments.

  - Alerts for scheduling conflicts and available discounts.


- **Product Management**

  - Add products to a shopping cart, favorite products, and check out.

  - Inventory management for the salon manager.


### Payment Processing

- Support for cash and card payments, with partial payments allowed.

- Integration with **Stripe** for secure credit card transactions.


### Staff Management

- Detailed staff profiles, including specialties and customer reviews.

- Schedule management and access to comprehensive reporting and analytics for the salon manager.


## Technology Stack

- **Frontend**: Angular

- **Backend**: .NET

- **Database**: PostgreSQL

- **User Authentication**: Keycloak

## Prerequisites

- [Angular 22.11.0](https://nodejs.org/en/download/package-manager)
- [.NET 8.0](https://dotnet.microsoft.com/en-us/download/dotnet/8.0)
- [PostgreSQL 16.4](https://www.postgresql.org/download/)
- [Keycloak 26.0.5](https://www.keycloak.org/downloads)


## Getting Started
To get a local copy of the project up and running, follow these steps:

**1. Clone the repository:**
```bash
git clone https://github.com/andrewzgheib/Beauty-Salon-Management-System.git
```

**2. Set up a database in PostgreSQL**
```pgsql
CREATE DATABASE <database>;
```

**3. Run the SQL script**

The [`script.sql`](https://github.com/andrewzgheib/Beauty-Salon-Management-System/blob/main/script.sql) file in the repository contains the SQL script necessary to set up the PostgreSQL database for BSMS.


**6. Build and run the application.**
