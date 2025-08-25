import { DataSource } from 'typeorm';
import { Seeder, SeederFactoryManager } from 'typeorm-extension';

export class TestSeeder implements Seeder {
  track = true;

  public async run(
    dataSource: DataSource,
    _: SeederFactoryManager,
  ): Promise<any> {
    // eslint-disable-next-line no-console
    console.log('Test seeder is running!');

    // Just do a simple query to test
    await dataSource.query('SELECT 1 as test');

    // eslint-disable-next-line no-console
    console.log('Test seeder completed!');
  }
}
