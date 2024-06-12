import 'package:flutter/material.dart';
import 'package:micro_cow_app/main.dart';

class WelcomeUser extends StatelessWidget {
  const WelcomeUser({
    super.key,
    required this.account,
  });

  final String account;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: const Color.fromRGBO(2, 117, 216, 0.65)),
              ),
              child: Text(
                'hi, $account',
                style: context.style.titleMedium?.copyWith(
                  color: blueShadow,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BalanceDisplay extends StatelessWidget {
  const BalanceDisplay({
    super.key,
    required this.balance,
  });

  final double balance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: const Color.fromRGBO(244, 67, 54, 0.6)),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(244, 67, 54, 0.6),
                    offset: Offset(0, 8),
                    blurRadius: 25,
                    spreadRadius: 0.25,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                    decoration: BoxDecoration(
                      color: redShadow,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      border: Border.all(color: const Color.fromRGBO(244, 67, 54, 0.6)),
                    ),
                    child: Text(
                      'BALANCE',
                      style: context.style.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      border: Border.all(color: const Color.fromRGBO(244, 67, 54, 0.6)),
                    ),
                    child: Text(
                      '${balance.round()} LINERA',
                      style: context.style.titleMedium?.copyWith(
                        color: redShadow,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
